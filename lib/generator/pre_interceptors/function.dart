library jaguar.generator.pre_interceptor_function;

class PreInterceptorFunction {
  final List<String> authorizedMethods;
  final bool allowMultiple;
  final List<Type> postInterceptors;

  const PreInterceptorFunction(
      {this.authorizedMethods: const <String>[
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
      ],
      this.allowMultiple: false,
      this.postInterceptors: const <Type>[]});
}
