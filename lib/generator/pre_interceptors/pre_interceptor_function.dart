library jaguar.generator.pre_interceptor_function;

class PreProcessorFunction {
  final List<String> authorizedMethods;
  final bool allowMultiple;
  final List<Type> postProcessors;

  const PreProcessorFunction(
      {this.authorizedMethods: const <String>[
        'GET',
        'POST',
        'PUT',
        'PATCH',
        'DELETE',
        'OPTIONS'
      ],
      this.allowMultiple: false,
      this.postProcessors: const <Type>[]});
}
