part of jaguar.throttle;

/// Contains count information for a single throttle identifier/key
class ThrottleData {
  /// Count
  int count = 0;

  /// Start of the recorded time interval
  int milliseconds = 0;

  ThrottleData();

  ThrottleData.now(this.count)
      : milliseconds = new DateTime.now().millisecondsSinceEpoch;

  ThrottleData.make(this.count, this.milliseconds);

  /// Returns time
  DateTime time() => new DateTime.fromMillisecondsSinceEpoch(milliseconds);

  /// Increments the count
  ThrottleData inc(int milliseconds) =>
      new ThrottleData.make(count + 1, milliseconds);
}
