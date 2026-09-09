"""Protect the core Apex API signatures and thin service/implementation boundary.

Uses only Python's standard library. Intentional API changes require an explicit
update to tests/contracts/core-services.json alongside consumer validation.
"""

import json
import re
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
CLASSES = ROOT / "force-app/main/default/classes"
BASELINE = ROOT / "tests/contracts/core-services.json"


def mask_comments_and_strings(source):
    """Keep positions intact while excluding braces inside comments/literals."""
    return re.sub(
        r"//[^\n]*|/\*[\s\S]*?\*/|'(?:\\.|[^'\\])*'",
        lambda match: "".join("\n" if char == "\n" else " " for char in match[0]),
        source,
    )


def check():
    errors = []
    count = 0
    for name, expected in json.loads(BASELINE.read_text()).items():
        source = (CLASSES / (name + ".cls")).read_text()
        masked = mask_comments_and_strings(source)
        operation = name.removesuffix("Service") + "Operations"
        signatures = []
        for match in re.finditer(
            r"\bglobal\s+static\s+(\w+)\s+(\w+)\s*\(([^)]*)\)\s*\{", masked
        ):
            begin = match.end()
            end, depth = begin, 1
            while depth and end < len(masked):
                depth += (masked[end] == "{") - (masked[end] == "}")
                end += 1
            signature = " ".join(source[match.start() : begin - 1].split())
            signatures.append(signature)
            params = [item.strip().split()[-1] for item in match[3].split(",") if item.strip()]
            statement = (
                ("" if match[1] == "void" else "return ")
                + operation + "." + match[2] + "(" + ",".join(params) + ");"
            )
            actual = re.sub(r"\s+", "", source[begin : end - 1])
            if actual != re.sub(r"\s+", "", statement):
                errors.append(name + "." + match[2] + ": public method must only delegate")
            count += 1
        if signatures != expected:
            errors.append(name + ": public signature/overload baseline changed; review consumer compatibility")
        implementation = mask_comments_and_strings((CLASSES / (operation + ".cls")).read_text())
        if re.search(r"\bglobal\b", implementation):
            errors.append(operation + ": implementation must not be global")
        if re.search(r"\bChrono\w+Service\s*\.", implementation):
            errors.append(operation + ": core implementation must call internal operations directly")
    if errors:
        raise SystemExit("\n".join(errors))
    print(f"Verified {count} reviewed core API signatures and thin internal delegation.")


if __name__ == "__main__":
    check()
