# jaguar_throttle

Rate limiter for Jaguar

# Usage

```dart
@Api()
class ExampleApi {
  Throttler throttle(_) =>
      new Throttler(new Rate(new Duration(seconds: 10), 100));

  @Get(path: '/hello')
  @WrapOne(#throttle)
  String sayHello(Context ctx) => 'hello';
}
```
# Docs

## Quota

`Rate` class provides an easy to define count per time interval. It is used to specify throttling quote of the `Throttler`. 

The constructor of `Rate` takes interval in `Duration` and count.

    Rate(Duration interval, int count);

  
To create a rate of 100 requests per 10 seconds:

    new Rate(new Duration(seconds: 10), 100);

## Id maker
[`ThrottleIdMaker`][ThrottleIdMaker] creates the criteria by which requests are throttled. `ThrottleIdMaker` is a function that takes [`Context`][Context] object and returns a `String` identifying the request.

```dart
typedef FutureOr<String> ThrottleIdMaker(Context ctx);
```

By default, `Throttler` uses [`throttleIdByIp`][throttleIdByIp] as `ThrottleIdMaker`. `throttleIdByIp` throttles requests by remote IP address.

## Store
`Throttler` uses [`Cache`][Cache] to store request count stats. By default, [`defaultThrottleCache`][defaultThrottleCache], which is an [`InMemoryCache`][InMemoryCache], is used as store.

## Headers

`Throttler` sets `X-RateLimit-Limit`, `X-RateLimit-Remaining` and `X-RateLimit-Reset` rate-limit headers with quota, quota remaining and duration in seconds after which quota resets respectively. In case, the quota for the current interval is completely used, `Throttler` also sets the header `Retry-After` with duration in seconds after which the client can retry.

[jaguar_throttle]: https://github.com/Jaguar-dart/jaguar_throttle
[Context]: https://www.dartdocs.org/documentation/jaguar/latest/jaguar/Context-class.html
[throttleIdByIp]: https://www.dartdocs.org/documentation/jaguar_throttle/latest/jaguar_throttle/throttleIdByIp.html
[defaultThrottleCache]: https://www.dartdocs.org/documentation/jaguar_throttle/latest/jaguar_throttle/defaultThrottleCache.html
[ThrottleIdMaker]: https://www.dartdocs.org/documentation/jaguar_throttle/latest/jaguar_throttle/ThrottleIdMaker.html
[Cache]: https://www.dartdocs.org/documentation/jaguar_cache/latest/jaguar_cache/Cache-class.html
[InMemoryCache]: https://www.dartdocs.org/documentation/jaguar_cache/latest/jaguar_cache/InMemoryCache-class.html
