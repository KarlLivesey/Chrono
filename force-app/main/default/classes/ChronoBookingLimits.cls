// Copyright (c) 2026, Karl. SPDX-License-Identifier: BSD-3-Clause
/** @description Applies booking constraints to exact free windows. Buffer time must also be open and unoccupied. */
public with sharing class ChronoBookingLimits {
  public static List<ChronoIntervals.Span> apply(
    ChronoAvailabilityInput input,
    List<ChronoIntervals.Span> windows
  ) {
    Long before = nonNegative(input.bufferBefore);
    Long after = nonNegative(input.bufferAfter);
    Boolean bounded =
      !String.isBlank(input.minimumNotice) ||
      !String.isBlank(input.bookingHorizon);
    if (bounded) {
      ChronoSupport.requireValue(
        input.referenceInstant,
        'Reference datetime for booking limits'
      );
    }
    Long earliest = bounded
      ? input.referenceInstant.getTime() + nonNegative(input.minimumNotice)
      : null;
    Long latest = String.isBlank(input.bookingHorizon)
      ? null
      : input.referenceInstant.getTime() +
        ChronoAvailability.elapsed(input.bookingHorizon);
    List<ChronoIntervals.Span> result = new List<ChronoIntervals.Span>();
    for (ChronoIntervals.Span window : windows) {
      Long start = window.start + before;
      Long finish = window.finish - after;
      if (earliest != null) {
        start = Math.max(start, earliest);
      }
      if (latest != null) {
        finish = Math.min(finish, latest);
      }
      if (start < finish) {
        result.add(ChronoIntervals.span(start, finish));
      }
    }
    return result;
  }
  public static Long firstStart(Long opening, Long step, Datetime anchor) {
    if (anchor == null) {
      return opening;
    }
    Long remainder = Math.mod(opening - anchor.getTime(), step);
    if (remainder < 0) {
      remainder += step;
    }
    return remainder == 0 ? opening : opening + step - remainder;
  }
  private static Long nonNegative(String iso) {
    if (String.isBlank(iso)) {
      return 0L;
    }
    ChronoDuration duration = ChronoDurationService.parseIso(iso);
    if (
      duration.months != 0 ||
      duration.days != 0 ||
      duration.milliseconds < 0
    ) {
      throw new ChronoException(
        'Booking limits require non-negative elapsed durations without calendar units.'
      );
    }
    return duration.milliseconds;
  }
}
