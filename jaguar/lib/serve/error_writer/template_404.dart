part of 'error_writer.dart';

/// Creates body for 404 html response
String _write404Html(Context ctx) => '''
<!DOCTYPE>
<html>
<head>
  <title>404 - Not found!</title>
  <style>
    body, html {
      margin: 0px;
      padding: 0px;
      border: 0px;
      font-family: monospace, sans-serif;
      background-color: #e4e4e4;
    }
    .content {
      width: 100%;
      height: 100%;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
    }
    .title {
      font-size: 30px;
      margin: 10px 0px;
    }
    .info {
      font-size: 16px;
      margin: 5px 0px;
    }
  </style>
</head>
<body>
  <div class="content">
    <div class="title">Not found!</div>
    <div class="info">Path: <i>${ctx.path}</i></div>
    <div class="info">Method: <i>${ctx.method}</i></div>
  </div>
</body>
</html>
''';
