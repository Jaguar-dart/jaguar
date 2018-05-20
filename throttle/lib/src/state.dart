part of jaguar.throttle;

/// Contains the throttle state information
class ThrottleState {
  /// Max quota
  final int quota;

  /// Remaining quota
  final int remaining;

  /// Duration after which quota resets
  final int resetsIn;

  /// Duration after which client can retry in case quota is fully used
  final int retryAfter;

  ThrottleState(this.quota, this.remaining, this.resetsIn, this.retryAfter);

  factory ThrottleState.make(int quota, ThrottleData data, Duration interval) {
    if (data == null) {
      return new ThrottleState(quota, quota, interval.inSeconds, -1);
    }

    int remaining = max(0, quota - data.count);
    int resetsIn = max(0, data.time().difference(new DateTime.now()).inSeconds);
    int retryAfter = -1;
    if (quota <= data.count) {
      retryAfter = max(0,
          data.time().add(interval).difference(new DateTime.now()).inSeconds);
    }
    return new ThrottleState(quota, remaining, resetsIn, retryAfter);
  }

  void setHeaders(Response resp) {
    resp.headers.set('X-RateLimit-Limit', quota.toString());
    resp.headers.set('X-RateLimit-Remaining', remaining.toString());
    resp.headers.set('X-RateLimit-Reset', resetsIn.toString());
    if (retryAfter >= 0) resp.headers.set('Retry-After', retryAfter.toString());
  }
}