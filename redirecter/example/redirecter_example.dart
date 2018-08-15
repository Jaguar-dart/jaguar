import 'dart:io';
import 'package:jaguar_redirecter/jaguar_redirecter.dart';
import 'package:jaguar/jaguar.dart';

main() async {
  // Create SecurityContext from certificate and private key
  final security = new SecurityContext()
    ..useCertificateChain("example/ssl/certificate.pem")
    ..usePrivateKey("example/ssl/keys.pem");

  // The actual HTTPS server
  final server = Jaguar(port: 443, securityContext: security);

  // A sample HTML route
  server.html(
      '/math/add.html',
      (ctx) => """
<html><head><title>Example</title>
<link rel="stylesheet" type="text/css" href="style.css">
</head><body><div id='result'>Result: ${ctx.query.getInt('a') + ctx.query.getInt('b')}</div></body></html>  
  """);

  // A sample CSS route
  server.get('/math/style.css', (ctx) => Response("""
#result { font-weight: bold; color: blue; }  
  """, mimeType: MimeTypes.css));
  server.log.onRecord.listen(print);
  await server.serve(logRequests: true);

  // HTTP to HTTPS redirecter
  final redir = Jaguar(port: 10000);
  redir.addRoute(httpsRedirecter());
  await redir.serve();
}
