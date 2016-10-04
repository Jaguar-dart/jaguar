library jaguar.generator.writer;

import 'dart:convert';

import 'pre_processor/pre_processor.dart';
import 'post_processor/post_processor.dart';
import 'route/route_information_generator.dart';

class Writer {
  final String className;
  StringBuffer sb;
  List<RouteInformationsGenerator> routes;

  Writer(this.className) {
    sb = new StringBuffer();
    routes = <RouteInformationsGenerator>[];
  }

  void addAllRoutes(List<RouteInformationsGenerator> newRoutes) {
    routes.addAll(newRoutes);
  }

  void generateClass() {
    sb.writeln("abstract class _\$Jaguar$className {");
    sb.writeln("List<RouteInformations> _routes = <RouteInformations>[");
    routes.forEach((RouteInformationsGenerator route) {
      sb.writeln(
          "new RouteInformations(r\"${route.routeProcessor.path}\", ${JSON.encode(route.routeProcessor.methods)}),");
    });
    sb.writeln("];");
    sb.writeln("");

    _generateHandleApiRequest();

    sb.writeln("}");
  }

  String toString() {
    generateClass();
    return sb.toString();
  }

  void _generateHandleApiRequest() {
    sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
    sb.writeln("List<String> args = <String>[];");
    sb.writeln("bool match = false;");
    for (int i = 0; i < routes.length; i++) {
      sb.writeln(
          "match = _routes[$i].matchWithRequestPathAndMethod(args, request.uri.path, request.method);");
      sb.writeln("if (match) {");

      _generatePreProcessor(routes[i]);

      _generateProcessor(routes[i]);

      bool handleResponse = _generatePostProcessor(routes[i]);

      if (!handleResponse) {
        sb.write("request.response.write(result);");
      }
      // _sendResponse(routes[i]);

      sb.writeln("return true;");
      sb.writeln("}");
    }
    sb.writeln("return false;");
    sb.writeln("}");
    sb.writeln("");
  }

  void preProcessorHasNeededPostProcessor(
      RouteInformationsGenerator route, PreProcessor preProcessor) {
    if (preProcessor.callPostProcessorsAfter.isNotEmpty) {
      for (int j = 0; j < preProcessor.callPostProcessorsAfter.length; j++) {
        bool ok = false;
        for (int i = 0; i < route.postProcessor.length; i++) {
          if (preProcessor.callPostProcessorsAfter[j] ==
              route.postProcessor[i].runtimeType.toString()) {
            ok = true;
            break;
          }
        }
        if (!ok) {
          throw "${preProcessor.runtimeType.toString()} need ${preProcessor.callPostProcessorsAfter[j]} to work";
        }
      }
    }
  }

  void _generatePreProcessor(RouteInformationsGenerator route) {
    List<PreProcessor> preProcessors = route.preProcessors
        .where((PreProcessor preProcessor) => preProcessor.methods.any(
            (String method) => route.routeProcessor.methods.contains(method)))
        .toList();
    preProcessors.sort((PreProcessor p1, PreProcessor p2) {
      if (p1.variableName == null && p2.variableName != null) {
        return -1;
      }
      return 1;
    });
    Map<String, int> numberPreProcessor = <String, int>{};
    preProcessors.forEach((PreProcessor preProcessor) {
      String type = preProcessor.runtimeType.toString();
      if (!numberPreProcessor.containsKey(type)) {
        numberPreProcessor[type] = 0;
      } else {
        numberPreProcessor[type] += 1;
      }
      // preProcessorHasNeededPostProcessor(route, preProcessor);
      preProcessor.callProcessor(sb, numberPreProcessor[type]);
    });
  }

  void _generateProcessor(RouteInformationsGenerator route) {
    List<PreProcessor> preProcessors = route.preProcessors.where(
        (PreProcessor preProcessor) =>
            preProcessor.methods.any((String method) =>
                route.routeProcessor.methods.contains(method)) &&
            preProcessor.variableName != null);
    ;
    sb.write(route.routeProcessor.generateCall(preProcessors));
  }

  void postProcessorHasNeededPreProcessor(
      RouteInformationsGenerator route, PostProcessor postProcessor) {
    if (postProcessor.preProcessors.isNotEmpty) {
      for (int j = 0; j < postProcessor.preProcessors.length; j++) {
        bool ok = false;
        for (int i = 0; i < route.preProcessors.length; i++) {
          if (postProcessor.preProcessors[j] ==
              route.preProcessors[i].runtimeType.toString()) {
            ok = true;
            break;
          }
        }
        if (!ok) {
          throw "${postProcessor.runtimeType.toString()} need ${postProcessor.preProcessors[j]} to work";
        }
      }
    }
  }

  bool _generatePostProcessor(RouteInformationsGenerator route) {
    Map<String, int> numberPostProcessor = <String, int>{};
    bool someoneTakeTheResponse = false;
    route.postProcessor.forEach((PostProcessor postProcessor) {
      String type = postProcessor.runtimeType.toString();
      if (!numberPostProcessor.containsKey(type)) {
        numberPostProcessor[type] = 0;
      } else {
        numberPostProcessor[type] += 1;
      }
      if (!someoneTakeTheResponse) {
        someoneTakeTheResponse = postProcessor.takeResponse;
      } else if (someoneTakeTheResponse && postProcessor.takeResponse) {
        throw "Someone already take charge of sending the response";
      }
      // postProcessorHasNeededPreProcessor(route, postProcessor);
      postProcessor.callProcessor(sb, numberPostProcessor[type]);
    });
    numberPostProcessor.clear();
    route.preProcessors.forEach((PreProcessor preProcessor) {
      preProcessor.callPostProcessorsAfter
          .forEach((PostProcessor postProcessor) {
        String type = postProcessor.runtimeType.toString();
        if (!numberPostProcessor.containsKey(type)) {
          numberPostProcessor[type] = 0;
        } else {
          numberPostProcessor[type] += 1;
        }
        postProcessor.callProcessor(sb, numberPostProcessor[type]);
      });
    });
    return someoneTakeTheResponse;
  }

  // _sendResponse(RouteInformationsGenerator route) {
  //   bool hasEncodeResponseToJson = route.postProcessor.any(
  //       (PostProcessor postProcessor) =>
  //           postProcessor.runtimeType.toString() ==
  //           'EncodeResponseToJsonPostProcessor');
  //   if (hasEncodeResponseToJson) {
  //     sb.writeln("int length = UTF8.encode(response).length;");
  //     sb.write("request.response");
  //     sb.write("..headers.add('Content-Type', 'application/json')");
  //     sb.write("..contentLength = length");
  //     sb.writeln('..write(response);');
  //     return;
  //   }
  //   sb.writeln("request.response.write(result);");
  //   return;
  // }
}

// import 'dart:convert';
//
// import 'route.dart';
// import 'processor.dart';
// import 'pre_processor.dart';
// import 'post_processor.dart';
//
// class Writer {
//   StringBuffer _sb;
//   List<RouteInformationsGenerator> _routes;
//
//   String className;
//
//   Writer(this.className) {
//     _sb = new StringBuffer();
//     _routes = <RouteInformationsGenerator>[];
//   }
//
//   void addAllRoutes(List<RouteInformationsGenerator> routes) {
//     _routes.addAll(routes);
//   }
//
//   String generate() {
//     _sb.writeln("abstract class _\$Jaguar$className {");
//     _sb.writeln("List<RouteInformations> _routes = <RouteInformations>[");
//     _routes.forEach((RouteInformationsGenerator route) {
//       _sb.writeln(
//           "new RouteInformations(\"${route.processor.path}\", ${JSON.encode(route.processor.methods)}),");
//     });
//     _sb.writeln("];");
//     _sb.writeln("");
//
//     _generateProcessorFunction(_sb);
//
//     _generateHandleApiRequest();
//
//     _sb.writeln("}");
//
//     return _sb.toString();
//   }
//
//   void _checkIfNeededAndAdd(
//       Processor processor, List<String> processors, StringBuffer sb) {
//     if (!processors.contains(processor.runtimeType.toString())) {
//       processors.add(processor.runtimeType.toString());
//       processor.dependsOn.forEach((PreProcessor dependOn) {
//         if (!processors.contains(dependOn.runtimeType.toString())) {
//           dependOn.generateFunction(sb);
//           processors.add(dependOn.runtimeType.toString());
//         }
//       });
//       processor.generateFunction(sb);
//     }
//   }
//
//   void _generateProcessorFunction(StringBuffer sb) {
//     List<String> preProcessors = <String>[];
//     List<String> postProcessors = <String>[];
//     for (int i = 0; i < _routes.length; i++) {
//       _routes[i].preProcessor.forEach((PreProcessor preProcessor) {
//         _checkIfNeededAndAdd(preProcessor, preProcessors, sb);
//       });
//       _routes[i].postProcessor.forEach((PostProcessor postProcessor) {
//         _checkIfNeededAndAdd(postProcessor, postProcessors, sb);
//       });
//     }
//   }
//
//   void _generateHandleApiRequest() {
//     _sb.writeln("Future<bool> handleApiRequest(HttpRequest request) async {");
//     _sb.writeln("List<String> args = <String>[];");
//     _sb.writeln("bool match = false;");
//     for (int i = 0; i < _routes.length; i++) {
//       _sb.writeln(
//           "match = _routes[$i].matchWithRequestPathAndMethod(args, request.uri.path, request.method);");
//       _sb.writeln("if (match) {");
//
//       _generatePreProcessor(_routes[i]);
//
//       _generateProcessor(_routes[i]);
//
//       _generatePostProcessor(_routes[i]);
//
//       _sendResponse(_routes[i]);
//
//       _sb.writeln("return true;");
//       _sb.writeln("}");
//     }
//     _sb.writeln("return false;");
//     _sb.writeln("}");
//     _sb.writeln("");
//   }
//
//   void _generatePreProcessor(RouteInformationsGenerator route) {
//     for (int j = 0; j < route.preProcessor.length; j++) {
//       PreProcessor preProcessor = route.preProcessor[j];
//       if (preProcessor.authorizedMethods
//           .any((String method) => route.processor.methods.contains(method))) {
//         _sb.write(preProcessor.generateCall());
//       }
//     }
//   }
//
//   void _generateProcessor(RouteInformationsGenerator route) {
//     _sb.write(route.processor.generateCall());
//   }
//
//   void _generatePostProcessor(RouteInformationsGenerator route) {
//     for (int i = 0; i < route.postProcessor.length; i++) {
//       PostProcessor postProcessor = route.postProcessor[i];
//       _sb.write(postProcessor.generateCall());
//     }
//   }
//
//   _sendResponse(RouteInformationsGenerator route) {
//     bool hasEncodeResponseToJson = route.postProcessor.any(
//         (PostProcessor postProcessor) =>
//             postProcessor.runtimeType.toString() ==
//             'EncodeResponseToJsonPostProcessor');
//     if (hasEncodeResponseToJson) {
//       _sb.writeln("int length = UTF8.encode(response).length;");
//       _sb.write("request.response");
//       _sb.write("..headers.add('Content-Type', 'application/json')");
//       _sb.write("..contentLength = length");
//       _sb.writeln('..write(response);');
//       return;
//     }
//     _sb.writeln("request.response.write(result);");
//     return;
//   }
// }
