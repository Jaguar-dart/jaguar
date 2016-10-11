// GENERATED CODE - DO NOT MODIFY BY HAND

part of jaguar.generator.post_processor.post_processor_function;

// **************************************************************************
// Generator: PostProcessorFunctionAnnotationGenerator
// Target: encodeStringToJson
// **************************************************************************

class EncodeStringToJson extends PostProcessor {
  const EncodeStringToJson()
      : super(
          returnType: 'void',
          functionName: 'encodeStringToJson',
          parameters: const <Parameter>[
            const Parameter(type: HttpRequest, name: 'request'),
            const Parameter(type: String, name: 'result'),
          ],
          allowMultiple: false,
          takeResponse: true,
        );
}

// **************************************************************************
// Generator: PostProcessorFunctionAnnotationGenerator
// Target: encodeMapOrListToJson
// **************************************************************************

class EncodeMapOrListToJson extends PostProcessor {
  const EncodeMapOrListToJson()
      : super(
          returnType: 'void',
          functionName: 'encodeMapOrListToJson',
          parameters: const <Parameter>[
            const Parameter(type: HttpRequest, name: 'request'),
            const Parameter(type: dynamic, name: 'result'),
          ],
          allowMultiple: false,
          takeResponse: true,
        );
}
