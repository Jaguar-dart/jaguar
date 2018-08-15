# jaguar_redirecter

Plugin to perform HTTP to HTTPS redirection or redirection to another
server.

## HTTPS redirection

```
  // HTTP to HTTPS redirecter
  final redir = Jaguar(port: 10000);
  redir.addRoute(httpsRedirecter());
  await redir.serve();
```
