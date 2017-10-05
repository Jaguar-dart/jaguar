# Changelog

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