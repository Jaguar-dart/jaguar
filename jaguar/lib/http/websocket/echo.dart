part of 'websocket.dart';

RouteHandler wsEcho() {
  return (Context ctx) async {
    final WebSocket ws = await ctx.req.upgradeToWebSocket;
    ctx.response = SkipResponse();

    ws.listen((data) {
      ws.add(data);
    }, cancelOnError: true);
  };
}
