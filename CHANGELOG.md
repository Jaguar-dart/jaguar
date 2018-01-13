# Changelog

## 1.2.6

+ `Wrap` and `WrapOne` take function or `Symbol` as interceptor creator

## 1.2.2-dev

+ Loosened type of `WrapOne`

## 1.2.1-dev

+ `Wrap` and `WrapOne` take function as interceptor creator
+ `parse` and `write` methods of `SessionManager` takes `Context` instead of `Request`
+ Removed session related methods and fields from `Request`

## 0.7.1

+ Stripped out all mirror dependent elements to `jaguar_reflect`
+ Added `RouteChainSimple` to improve performance
+ Renamed `queryParams` to `query`

## 0.6.27

+ Widened dependency on meta package

## 0.6.27

+ Widened dependency on args package

## 0.6.26

+ Simplified request handling code

## 0.6.25

+ `Context` gets session accessors `session` and `parsedSession`

## 0.6.24

+ Fixed `RouteChain` building issue

## 0.6.23

+ Added `staticFiles` method to `Jaguar` to serve static files!
+ Added `staticFile` method to `Jaguar` to serve a single static file!

### Breaking Changed

+ Renamed `ReflectedRoute` to `RouteChain`
+ Renamed `JaguarReflected` to `ReflectedApi`
+ Renamed `reflectJaguar` to `reflectApi`

## 0.6.22
+ Added `html`, `json`, `getJson`, `putJson`, `postJson`, `deleteJson` methods to `Muxable` and `RouteBuilder`

## 0.6.21

+ Added `socketHandler` to make WebSocket handling easier

## 0.6.20

+ Preserve order of RequestHandlers

## 0.6.19

- Bug fix for `Session`

## 0.6.18

- Sessions are now only written when necessary
- Added HMAC based signing to session data

## 0.6.14

- `Session` in `Request`
- `SessionManager` in `Jaguar` to parse and write session data

## 0.6.13

- `bodyAsText`'s encoding parameter is optional

## 0.6.12

- Upgraded intl dependency

## 0.6.11

- Bootstrapping root APIs using `bootstrap` method
- Supports `package:dice` based DI during bootstrapping

## 0.6.10

- Jaguar shall log only unknown exceptions

## 0.6.9

- Return types of route handlers are now `FutureOr` 

## 0.6.8

- Mux methods now take response members
- Definition of `RouteHandlerFunc`

## 0.6.7

- `wrap` method on `Jaguar`

## 0.6.6

- XML rendering support
- **New error rendering mechanism**
- Debug stream

## 0.6.5

- Merged jaguar_reflect and jaguar_mux into jaguar core

## 0.6.1

- Global interceptors

## 0.6.0

- `Context` based `RequestHandler`

## 0.5.10

- Expose Logger to `Interceptors` and `Routes`
- Configurable `ErrorWriter`

## 0.5.9

- Fixed writing headers to response by `Response`

## 0.5.4

- Added `redirect` to `Response` class

## 0.5.0

- Removed RouteWrapper
- Removed injection

## 0.2.7
- Added properly handling `List<int>` response type
- Implemented Route redirection

## 0.1.14
- Remove Settings from Configuration

## 0.1.13

- Removed isolate creation. Control is given to the programmer.
- Bug fix for "Page not found!" error

## 0.0.3

**Breaking Changes**:

Annotation to build annotation from annotated function has changed.<br>
- `PreProcessorFunction` has changed to `PreInterceptorFunction`
- `PostProcessorFunction` has changed to `PostInterceptorFunction`

`jaguar.yaml` parameters has also changed
- `pre_processors` has changed to `pre_interceptors`
- `post_processors` has changed to `post_interceptors`