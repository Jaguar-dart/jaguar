// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.src.interceptors.pre;

// **************************************************************************
// Generator: PreInterceptorGenerator
// Target: getStringFromBody
// **************************************************************************

class GetStringFromBody extends PreProcessor {
  const GetStringFromBody()
      : super(
          returnType: 'Future<String>',
          variableName: '_getStringFromBody',
          functionName: 'getStringFromBody',
          parameters: const <Parameter>[
            const Parameter(type: HttpRequest, name: 'request'),
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
// Generator: PreInterceptorGenerator
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
            const Parameter(type: HttpRequest, name: 'request'),
            const Parameter(type: String, value: 'mimeType'),
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
// Generator: PreInterceptorGenerator
// Target: getJsonFromBody
// **************************************************************************

class GetJsonFromBody extends PreProcessor {
  const GetJsonFromBody()
      : super(
          returnType: 'Future<String>',
          variableName: '_getJsonFromBody',
          functionName: 'getJsonFromBody',
          parameters: const <Parameter>[
            const Parameter(type: HttpRequest, name: 'request'),
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
// Generator: PreInterceptorGenerator
// Target: getFormDataFromBody
// **************************************************************************

class GetFormDataFromBody extends PreProcessor {
  const GetFormDataFromBody()
      : super(
          returnType: 'Future<Map<String, FormField>>',
          variableName: '_getFormDataFromBody',
          functionName: 'getFormDataFromBody',
          parameters: const <Parameter>[
            const Parameter(type: HttpRequest, name: 'request'),
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
