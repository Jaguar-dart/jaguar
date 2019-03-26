part of 'websocket.dart';

RouteHandler wsEcho() {
  return (Context ctx) async {
    final WebSocket ws = await ctx.req.upgradeToWebSocket;
    ctx.response = SkipResponse();

    StreamSubscription sub;

    sub = ws.listen((data) {
      ws.add(data);
    }, onDone: () async {
      await sub.cancel();
    }, onError: (_) async {
      await sub.cancel();
    }, cancelOnError: true);

    sub.onDone(() async {
      await ws.close();
    });
    sub.onError((_) async {
      await ws.close();
    });
  };
}
