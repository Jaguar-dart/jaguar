library jaguar.generator.post_interceptor_function;

class PostInterceptorFunction {
  final bool allowMultiple;
  final bool takeResponse;

  const PostInterceptorFunction({
    this.allowMultiple: false,
    this.takeResponse: false,
  });
}
