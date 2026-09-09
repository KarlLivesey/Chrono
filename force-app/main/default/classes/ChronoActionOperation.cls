// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Internal execution boundary. Flow receives concrete input and result types, never this interface. */
public interface ChronoActionOperation {
  Object evaluate(Object input);
  Type resultType();
}
