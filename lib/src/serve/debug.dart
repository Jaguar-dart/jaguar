part of jaguar.src.serve;

class DebugInfo {
  DateTime time;

  Duration duration;

  String path;

  String method;

  final Map<String, List<String>> reqHeaders = <String, List<String>>{};

  int statusCode;

  final Map<String, List<String>> respHeaders = <String, List<String>>{};

  final List<String> messages = <String>[];

  DebugInfo();

  factory DebugInfo.make(Context ctx, Response resp, DateTime start) {
    final ret = new DebugInfo();
    ret.path = ctx.path;
    ret.method = ctx.method;
    ctx.req.headers.forEach(
        (String key, List<String> values) => ret.reqHeaders[key] = values);
    resp.headers.forEach(
        (String key, List<String> values) => ret.reqHeaders[key] = values);
    ret.statusCode = resp.statusCode;
    ret.time = start;
    ret.duration = new DateTime.now().difference(start);
    ret.messages.addAll(ctx.debugMsgs);
    return ret;
  }
}

class DebugStream {
  final StreamController<DebugInfo> _controller =
      new StreamController<DebugInfo>.broadcast();

  Stream<DebugInfo> get onRequest => _controller.stream;

  Stream<DebugInfo> get onError => onRequest.where(
      (DebugInfo info) => info.statusCode < 200 && info.statusCode > 299);

  void _add(DebugInfo info) {
    _controller.add(info);
  }
}
