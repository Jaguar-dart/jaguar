import 'package:jaguar/jaguar.dart';

main() async {
  final server = new Jaguar();
  server.get('/api/add/:item', (ctx) async {
    final Session session = await ctx.session;
    final String newItem = ctx.pathParams['item'];

    final List<String> items = (session['items'] ?? '').split(',');

    // Add item to shopping cart stored on session
    if (!items.contains(newItem)) {
      items.add(newItem);
      session['items'] = items.join(',');
    }

    return Response.redirect('/');
  });
  server.get('/api/remove/:item', (ctx) async {
    final Session session = await ctx.session;
    final String newItem = ctx.pathParams['item'];

    final List<String> items = (session['items'] ?? '').split(',');

    // Remove item from shopping cart stored on session
    if (items.contains(newItem)) {
      items.remove(newItem);
      session['items'] = items.join(',');
    }

    return Response.redirect('/');
  });
  server.html('/', (ctx) async {
    final Session session = await ctx.session;

    final List<String> items = (session['items'] ?? '').split(',');

    final bool hasNexus = items.contains('nexus');
    final bool hasGalaxy = items.contains('galaxy');
    final bool hasIPhone = items.contains('iphone');

    return '''
<html>
  <head>
    <title>Shopping cart</title>
    <style>
      html, body {
        font-size: 40px;
      }
      
      .item-name {
        min-width: 200px;
        display: inline-block;
      }
    </style>
  </head>
  <body>
    <div>
      <div>
        <input type="checkbox" onclick="return false;" ${hasNexus?'checked':''}>
        <a href="/api/add/nexus" class="item-name">Nexus 6P</a>
        <a href="/api/remove/nexus">&#128465;</a>
      </div>
      <div>
        <input type="checkbox" onclick="return false;" ${hasGalaxy?'checked':''}>
        <a href="/api/add/galaxy" class="item-name">Galaxy S8</a>
        <a href="/api/remove/galaxy">&#128465;</a>
      </div>
      <div>
        <input type="checkbox" onclick="return false;" ${hasIPhone?'checked':''}>
        <a href="/api/add/iphone" class="item-name">iPhone 8</a>
        <a href="/api/remove/iphone">&#128465;</a>
      </div>
    </div>
  </body>
</html>  
  ''';
  });
  await server.serve();
}
