library jaguar.src.serve.error_writer;

import 'dart:io';
import 'package:stack_trace/stack_trace.dart';
import 'package:jaguar/src/error.dart';

void writeErrorPage(HttpResponse response, String resource, Object error,
    [StackTrace stack, int statusCode]) {
  if (error is JaguarError) {
    statusCode = error.statusCode;
  }

  String description = _getStatusDescription(statusCode);

  String formattedStack = null;
  if (stack != null) {
    formattedStack = Trace.format(stack);
  }

  String errorTemplate = '''<!DOCTYPE>
<html>
<head>
  <title>Jaguar Server - ${description != null ? description : statusCode}</title>
  <style>
    body, html {
      margin: 0px;
      padding: 0px;
      border: 0px;
    }
    .header {
      height:100px;
      background-color: rgba(204, 49, 0, 0.94);
      color:#F8F8F8;
      overflow: hidden;
    }
    .header p {
      font-family:Helvetica,Arial;
      font-size:36px;
      font-weight:bold;
      padding-left:10px;
      line-height: 30px;
    }
    .footer {
      margin-top:50px;
      padding-left:10px;
      height:20px;
      font-family:Helvetica,Arial;
      font-size:12px;
      color:#5E5E5E;
    }
    .content {
      font-family:Helvetica,Arial;
      font-size:18px;
      padding:10px;
    }
    .info {
      border: 1px solid #C3C3C3;
      margin-top: 10px;
      padding-left:10px;
      font-size: 14px;
    }
  </style>
</head>
<body>
  <div class="header" style="">
    <p>$statusCode ${description != null ? " - " + description : ""}</p>
  </div>
  <div class="content">
    <p><b>Resource: </b> $resource</p>
    <div class="info" style="display:${error != null ? "block" : "none"}">
      <pre>$error - ${formattedStack != null ? "\n\n" + formattedStack : ""}</pre>
    </div>
  </div>
  <div class="footer">Jaguar Server - 2016 - <a href="https://github.com/jaguar-dart">https://github.com/jaguar-dart</a></div>
</body>
</html>''';

  response.statusCode = statusCode;
  response.headers.set("content-type", "text/html");
  response.write(errorTemplate);
  response.close();
}

String _getStatusDescription(int statusCode) {
  switch (statusCode) {
    case HttpStatus.BAD_REQUEST:
      return "BAD REQUEST";
    case HttpStatus.NOT_FOUND:
      return "NOT FOUND";
    case HttpStatus.METHOD_NOT_ALLOWED:
      return "METHOD NOT ALLOWED";
    case HttpStatus.INTERNAL_SERVER_ERROR:
      return "INTERNAL SERVER ERROR";
    default:
      return null;
  }
}
