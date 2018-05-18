library example.simple;

import 'package:jaguar/jaguar.dart';
import 'package:jaguar_cors/jaguar_cors.dart';

main() async {
  final server = new Jaguar(port: 10000);

  server.get('/none', (_) => 'none', before: [cors(new CorsOptions())]);

  {
    final options = new CorsOptions(
        allowedOrigins: ['http://example.com', 'http://example1.com'],
        allowAllMethods: true,
        allowAllHeaders: true);
    server.get('/origins', (_) => 'origins', before: [cors(options)]);
  }

  {
    final options = new CorsOptions(
        allowedOrigins: ['http://example.com', 'http://example1.com'],
        allowAllMethods: true,
        allowAllHeaders: true);
    server.route('/origins', (_) => 'preflight',
        methods: ['OPTIONS'], before: [cors(options)]);
  }

  await server.serve();
}
