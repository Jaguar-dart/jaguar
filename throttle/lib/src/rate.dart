part of jaguar.throttle;

/// Rate structure. Holds [count] per [interval]
class Rate {
  /// The time duration of the interval
  final Duration interval;

  /// Count per interval
  final int count;

  const Rate(this.interval, this.count);

  /// Creates [Rate] with [count] per second
  const Rate.perSec(this.count) : interval = const Duration(seconds: 1);

  /// Creates [Rate] with [count] per minute
  const Rate.perMin(this.count) : interval = const Duration(minutes: 1);

  /// Creates [Rate] with [count] per hour
  const Rate.perHour(this.count) : interval = const Duration(hours: 1);

  /// Creates [Rate] with [count] per day
  const Rate.perDay(this.count) : interval = const Duration(days: 1);
}

/// Creates [Rate] with [count] per second
Rate perSec(int count) => new Rate.perSec(count);

/// Creates [Rate] with [count] per minute
Rate perMin(int count) => new Rate.perMin(count);

/// Creates [Rate] with [count] per hour
Rate perHour(int count) => new Rate.perHour(count);

/// Creates [Rate] with [count] per day
Rate perDay(int count) => new Rate.perDay(count);
