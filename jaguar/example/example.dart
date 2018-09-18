import 'package:jaguar/jaguar.dart';

main() => Jaguar(port: 10000)
  ..get('/', (ctx) => 'Hello world!')
  ..serve();
