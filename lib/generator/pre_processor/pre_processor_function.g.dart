// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.generator.pre_processor.pre_processor_function;

// **************************************************************************
// Generator: PreProcessorFunctionAnnotationGenerator
// Target: getStringFromBody
// **************************************************************************

class GetStringFromBody extends PreProcessor {
  const GetStringFromBody()
      : super(
          returnType: 'Future<String>',
          variableName: '_getStringFromBody',
          functionName: 'getStringFromBody',
          parameters: const <Parameter>[
            const Parameter(type: 'HttpRequest', name: 'request'),
          ],
          methods: const <String>[
            'POST',
            'PUT',
            'PATCH',
            'DELETE',
          ],
          allowMultiple: false,
        );
}

// **************************************************************************
// Generator: PreProcessorFunctionAnnotationGenerator
// Target: mustBeMimeType
// **************************************************************************

class MustBeMimeType extends PreProcessor {
  final String mimeType;

  const MustBeMimeType({
    this.mimeType,
  })
      : super(
          returnType: 'void',
          functionName: 'mustBeMimeType',
          parameters: const <Parameter>[
            const Parameter(type: 'HttpRequest', name: 'request'),
            const Parameter(type: 'String', value: 'mimeType'),
          ],
          methods: const <String>[
            'POST',
            'PUT',
            'PATCH',
            'DELETE',
          ],
          allowMultiple: false,
        );

  @override
  void fillParameters(StringBuffer sb) {
    sb.writeln('request,');
    sb.writeln('"$mimeType",');
  }
}

// **************************************************************************
// Generator: PreProcessorFunctionAnnotationGenerator
// Target: getJsonFromBody
// **************************************************************************

class GetJsonFromBody extends PreProcessor {
  const GetJsonFromBody()
      : super(
          returnType: 'Future<String>',
          variableName: '_getJsonFromBody',
          functionName: 'getJsonFromBody',
          parameters: const <Parameter>[
            const Parameter(type: 'HttpRequest', name: 'request'),
          ],
          methods: const <String>[
            'POST',
            'PUT',
            'PATCH',
            'DELETE',
          ],
          allowMultiple: false,
        );
}

// **************************************************************************
// Generator: PreProcessorFunctionAnnotationGenerator
// Target: getFormDataFromBody
// **************************************************************************

class GetFormDataFromBody extends PreProcessor {
  const GetFormDataFromBody()
      : super(
          returnType: 'Future<Map<String, FormField>>',
          variableName: '_getFormDataFromBody',
          functionName: 'getFormDataFromBody',
          parameters: const <Parameter>[
            const Parameter(type: 'HttpRequest', name: 'request'),
          ],
          methods: const <String>[
            'POST',
            'PUT',
            'PATCH',
            'DELETE',
          ],
          allowMultiple: false,
        );
}

// **************************************************************************
// Generator: PreProcessorFunctionAnnotationGenerator
// Target: openDbExample
// **************************************************************************

class OpenDbExample extends PreProcessor {
  final String dbName;

  const OpenDbExample({
    this.dbName,
  })
      : super(
            returnType: 'Future<String>',
            variableName: '_openDbExample',
            functionName: 'openDbExample',
            parameters: const <Parameter>[
              const Parameter(type: 'String', value: 'dbName'),
            ],
            methods: const <String>[
              'GET',
              'POST',
              'PUT',
              'PATCH',
              'DELETE',
              'OPTIONS',
            ],
            allowMultiple: true,
            postProcessors: const <String>[
              'CloseDbExample',
            ]);

  @override
  void fillParameters(StringBuffer sb) {
    sb.writeln('"$dbName",');
  }
}
