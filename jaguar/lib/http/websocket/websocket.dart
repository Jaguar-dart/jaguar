library jaguar.websocket;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:jaguar/jaguar.dart';

part 'commander.dart';
part 'echo.dart';
part 'responder.dart';
part 'stream.dart';

typedef WsOnConnect<T> = FutureOr<T> Function(Context ctx, WebSocket ws);
