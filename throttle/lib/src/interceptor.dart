part of jaguar.throttle;

/// Interceptor to rate-limit routes
class Throttler {
  /// Maximum number of requests allowed for the given [interval]
  final Rate quota;

  /// Identification maker. Creates an identification for the given request
  final ThrottleIdMaker idMaker;

  final Cache store;

  /// Provides an opportunity to create [Response] when rate-limit exceeds
  final RouteHandler<Response> failResponse;

  Throttler(this.quota,
      {ThrottleIdMaker idMaker, this.failResponse, Cache store})
      : store = store ?? defaultThrottleCache,
        idMaker = idMaker ?? throttleIdByIp;

  factory Throttler.perSec(int quota,
          {ThrottleIdMaker idMaker,
          RouteHandler<Response> failResponse,
          Cache store}) =>
      new Throttler(perSec(quota),
          idMaker: idMaker, failResponse: failResponse, store: store);

  factory Throttler.perMin(int quota,
          {ThrottleIdMaker idMaker,
          RouteHandler<Response> failResponse,
          Cache store}) =>
      new Throttler(perMin(quota),
          idMaker: idMaker, failResponse: failResponse, store: store);

  factory Throttler.perHour(int quota,
          {ThrottleIdMaker idMaker,
          RouteHandler<Response> failResponse,
          Cache store}) =>
      new Throttler(perHour(quota),
          idMaker: idMaker, failResponse: failResponse, store: store);

  factory Throttler.perDay(int quota,
          {ThrottleIdMaker idMaker,
          RouteHandler<Response> failResponse,
          Cache store}) =>
      new Throttler(perDay(quota),
          idMaker: idMaker, failResponse: failResponse, store: store);

  ThrottleState state;

  Future<void> before(Context ctx) async {
    final String throttleId = await idMaker(ctx);
    final ThrottleData count = await _visit(throttleId, quota.interval);

    state = new ThrottleState.make(quota.count, count, quota.interval);

    if (count == null) return;

    if (count.count > quota.count)
      throw failResponse != null
          ? await failResponse(ctx)
          : new Response('Limit exceeded', statusCode: 429);

    ctx.addVariable(state);
  }

  void after(Context ctx) => state.setHeaders(ctx.response);

  Future<ThrottleData> _visit(String identifier, Duration interval) async {
    ThrottleData ret = new ThrottleData.now(1);

    ThrottleData data;

    try {
      data = await store.read(identifier);
    } catch (e) {
      if (e != cacheMiss) rethrow;
    }

    final now = new DateTime.now();

    if (data == null) {
      ret = new ThrottleData.now(1);
    } else if (now.difference(data.time()) < interval) {
      ret = data.inc(data.milliseconds);
    } else {
      ret = new ThrottleData.now(1);
    }

    await store.upsert(identifier, ret);
    return ret;
  }
}
