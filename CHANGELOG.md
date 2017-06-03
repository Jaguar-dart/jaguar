# Changelog

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