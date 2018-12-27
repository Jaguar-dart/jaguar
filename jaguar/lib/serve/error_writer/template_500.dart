part of 'error_writer.dart';

/// Creates body for 500 html response
String _write500Html(Context ctx, Object error, [StackTrace stack]) {
  String stackInfo = "";
  if (stack != null) {
    stackInfo = '''
    <div class="info">
    <div class="info-title">Stack</div>
      <pre>${Trace.format(stack)}</pre>
    </div>
    ''';
  }

  return '''
<!DOCTYPE>
<html>
<head>
  <title>Server error</title>
  <style>
    body, html {
      margin: 0px;
      padding: 0px;
      border: 0px;
      background-color: #e4e4e4;
    }
    .header {
      font-family: Helvetica,Arial;
      font-size: 20px;
      line-height: 25px;
      background-color: rgba(204, 49, 0, 0.94);
      color: #F8F8F8;
      overflow: hidden;
      padding: 10px 10px;
      box-sizing: border-box;
      font-weight: bold;
    }
    .footer {
      padding-left:20px;
      height:20px;
      font-family:Helvetica,Arial;
      font-size:12px;
      color:#5E5E5E;
      margin-top: 10px;
    }
    .content {
      font-family:Helvetica,Arial;
      font-size:18px;
    }
    .info {
      border-bottom: 1px solid rgba(0, 0, 0, 0.21);
      padding: 15px;
      box-sizing: border-box;
    }
    .info-title {
      font-size: 20px;
      font-weight: bold;
      margin-bottom: 5px;
    }
    pre {
      margin: 0px;
    }
  </style>
</head>
<body>
  <div class="header" style="">Server error!</div>
  <div class="content">
    <div class="info">
      <div class="info-title">Message</div>
      <div>$error</div>
    </div>
    $stackInfo
    <div class="info">
      <div class="info-title">Request</div>
      <div>Resource: ${ctx.path}</div>
      <div>Method: ${ctx.method}</div>
    </div>
  </div>
  <div class="footer">Jaguar Server - 2016 - <a href="https://github.com/jaguar-dart">https://github.com/jaguar-dart</a></div>
</body>
</html>
''';
}
