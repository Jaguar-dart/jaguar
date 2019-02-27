import 'dart:async';
import 'dart:io';

import 'package:pedantic/pedantic.dart';

import 'package:jaguar/jaguar.dart';

import 'event.dart';

void _prepareResponse(HttpResponse response, {bool gzip = false}) {
  response.statusCode = 200;

  // Set content type to event-stream
  response.headers.set("Content-Type", "text/event-stream; charset=utf-8");

  // Disable caching
  response.headers.set("Cache-Control", "no-cache, no-store, must-revalidate");

  // Keep the connection alive
  response.headers.set("Connection", "keep-alive");

  // Will the response be encoded with gzip?
  if (gzip) response.headers.set("Content-Encoding", "gzip");
}

/// Upgrades HTTP request to event source.
Future<bool> toEventsource(Context ctx, {bool gzip: false}) async {
  // Use gzip if both server and client can handle it
  bool useGzip = gzip &&
      (ctx.headers.value(HttpHeaders.acceptEncodingHeader) ?? "")
          .contains("gzip");

  ctx.response = SkipResponse();

  HttpResponse response = ctx.req.ioRequest.response;

  // Prepare response
  _prepareResponse(response, gzip: useGzip);

  await response.flush();

  return useGzip;
}

/// Upgrades HTTP request to event source and streams [data] to it.
Future<void> eventsourceStreamer(Context ctx, Stream<String> data,
    {bool compress: false}) async {
  final useGzip = await toEventsource(ctx, gzip: compress);

  HttpResponse response = ctx.req.ioRequest.response;

  StreamSubscription sub;
  sub = data.listen(
      (d) {
        List<int> wire = Event.data(d).toUtf8;
        if (useGzip) wire = gzip.encode(wire);
        response.add(wire);
      },
      cancelOnError: true,
      onDone: () async {
        await sub.cancel();
        await response.flush();
        await response.close();
      },
      onError: () async {
        await sub.cancel();
        await response.flush();
        await response.close();
      });

  unawaited(response.done.then((_) async {
    await sub.cancel();
  }));
}

/// Upgrades HTTP request to event source and streams [events] to it.
Future<void> eventsourceEventStreamer(Context ctx, Stream<Event> events,
    {bool compress: false}) async {
  final useGzip = await toEventsource(ctx, gzip: compress);

  HttpResponse response = ctx.req.ioRequest.response;

  StreamSubscription sub;
  sub = events.listen(
      (d) {
        List<int> wire = d.toUtf8;
        if (useGzip) wire = gzip.encode(wire);
        response.add(wire);
      },
      cancelOnError: true,
      onDone: () async {
        await sub.cancel();
        await response.flush();
        await response.close();
      },
      onError: () async {
        await sub.cancel();
        await response.flush();
        await response.close();
      });

  unawaited(response.done.then((_) async {
    await sub.cancel();
  }));
}
