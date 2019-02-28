library eventsource.src.event;

import 'dart:convert';

class Event {
  final String id;

  final String event;

  String data;

  Event({this.id, this.event, this.data});

  Event.data(this.data)
      : id = null,
        event = null;

  String encode() {
    final sb = StringBuffer();
    if (id != null) sb.writeln("id:${id.replaceAll("\n", "\nid:")}");
    if (event != null)
      sb.writeln("event:${event.replaceAll("\n", "\nevent:")}");
    if (data != null) sb.writeln("data:${data.replaceAll("\n", "\ndata:")}");

    sb.write("\n");
    final ret = sb.toString();
    return ret;
  }

  List<int> get toUtf8 => utf8.encode(encode());
}
