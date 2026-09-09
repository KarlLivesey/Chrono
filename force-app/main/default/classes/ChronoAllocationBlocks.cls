// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Compiles and validates named recurring clock bands. */
public with sharing class ChronoAllocationBlocks {
  public static List<Block> compile(List<ChronoTimeBlock> values) {
    List<Block> blocks = new List<Block>();
    if (values == null || values.isEmpty() || values.size() > 50) {
      throw new ChronoException('Supply 1–50 time blocks.');
    }
    Set<String> keys = new Set<String>();
    for (ChronoTimeBlock value : values) {
      ChronoSupport.requireValue(value, 'Time block');
      if (String.isBlank(value.key) || keys.contains(value.key)) {
        throw new ChronoException(
          'Each time block needs a unique non-empty key.'
        );
      }
      keys.add(value.key);
      blocks.add(read(value));
    }
    return blocks;
  }
  private static Block read(ChronoTimeBlock value) {
    Block block = new Block();
    block.key = value.key;
    block.label = String.isBlank(value.label) ? value.key : value.label;
    String kind = String.isBlank(value.dayType) ? 'regular' : value.dayType;
    ChronoSupport.choice(
      kind,
      new Set<String>{ 'regular', 'holiday' },
      'block day type'
    );
    block.holiday = kind == 'holiday';
    block.days = weekdays(value.weekdays);
    block.start = clock(value.startTime, false);
    block.finish = clock(value.endTime, true);
    if (block.start == block.finish) {
      throw new ChronoException(
        'Block start and end must differ; use 00:00–24:00 for a full day.'
      );
    }
    if (block.finish < block.start) {
      block.finish += 86400000L;
    }
    return block;
  }
  private static Set<Integer> weekdays(String text) {
    Set<Integer> result = new Set<Integer>();
    for (
      String day : (String.isBlank(text) ? '1,2,3,4,5,6,7' : text).split(',')
    ) {
      if (!Pattern.matches('[1-7]', day.trim())) {
        throw new ChronoException(
          'Block weekdays must be comma-separated numbers 1–7 (Monday–Sunday).'
        );
      }
      result.add(Integer.valueOf(day.trim()));
    }
    return result;
  }
  private static Long clock(String text, Boolean allowEndOfDay) {
    if (
      allowEndOfDay &&
      new Set<String>{ '24:00', '24:00:00', '24:00:00.000' }.contains(text)
    ) {
      return 86400000L;
    }
    Time value = ChronoIso.parseTime(text);
    return ((Long) value.hour()) * 3600000L +
      value.minute() * 60000L +
      value.second() * 1000L +
      value.millisecond();
  }
  public class Block {
    public String key;
    public String label;
    public Set<Integer> days;
    public Boolean holiday;
    public Long start;
    public Long finish;
  }
}
