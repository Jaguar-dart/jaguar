import 'package:jaguar/jaguar.dart';

main() => Jaguar()
  ..get('/', (ctx) => 'Get')
  ..postJson('/json', (ctx) => {'method': 'post'})
  ..log.onRecord.listen(print)
  ..serve(logRequests: true);
