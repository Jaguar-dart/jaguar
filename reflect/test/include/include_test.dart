library test.jaguar.include;

import 'package:http/http.dart' as http;
import 'package:jaguar_resty/jaguar_resty.dart' as resty;
import 'package:test/test.dart';
import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/jaguar_reflect.dart';

void bef(Context ctx) => ctx.addVariable(5);

void aft(Context ctx) =>
    ctx.response = new Response(ctx.getVariable<int>() * 5);

void aft1(Context ctx) => ctx.addVariable(ctx.getVariable<int>() + 5);

void aft2(Context ctx) => ctx.addVariable(ctx.getVariable<int>() + 2);

void onExcept1(Context ctx, dynamic e, s) => throw Response(e.toString());

void progBef(Context ctx) {
  ctx.addVariable(5);
  ctx.after.add(aft1);
}

@Controller(path: '/sub')
class SubController {
  @Get(path: '/')
  String get(Context ctx) => 'Get';

  @Post(path: '/')
  String post(_) => 'Post';

  @Put(path: '/')
  String put(_) => 'Put';

  @Delete(path: '/')
  String delete(_) => 'Delete';

  @GetJson(path: '/json')
  Map getJson(_) => {'method': 'get'};

  @PostJson(path: '/json')
  Map postJson(_) => {'method': 'post'};

  @PutJson(path: '/json')
  Map putJson(_) => {'method': 'put'};

  @DeleteJson(path: '/json')
  Map deleteJson(_) => {'method': 'delete'};

  @Get(path: '/intercept')
  @Intercept(const [bef], after: const [aft])
  void intercept(Context ctx) => null;
}

@Controller(path: '/sub1')
class SubController1 {
  @Get(path: '/intercept')
  void intercept(Context ctx) => null;

  @Get(path: '/intercept1')
  @After(const [aft1])
  void intercept1(Context ctx) => null;

  @Get(path: '/progaft')
  @Intercept(const [progBef])
  void progaft(Context ctx) => null;

  @Get(path: '/except')
  void except(_) => throw 'except1';
}

@Controller()
@After(const [aft1])
@OnException(const [onExcept1])
class SubController2 {
  @Get(path: '/intercept')
  void intercept(Context ctx) => null;

  @Get(path: '/intercept1')
  @After(const [aft2])
  void intercept1(Context ctx) => null;

  @Get(path: '/except')
  void except1(_) => throw 'except1';
}

@Controller()
class ExampleController {
  @Get(path: '/hello')
  String hello(Context ctx) => 'Hello!';

  @IncludeHandler(path: '/api')
  final SubController subController = new SubController();

  @IncludeHandler()
  @Intercept(const [bef], after: const [aft])
  @OnException(const [onExcept1])
  final SubController1 subController1 = new SubController1();

  @IncludeHandler(path: '/sub2')
  @Intercept(const [bef], after: const [aft])
  final SubController2 subController2 = new SubController2();

  @Get(path: '/hello1')
  String hello1(Context ctx) => 'Hello1!';
}

void main() {
  resty.globalClient = new http.IOClient();

  group('Include', () {
    Jaguar server;
    setUpAll(() async {
      server = new Jaguar(port: 10000);
      server.add(reflect(new ExampleController()));
      await server.serve();
    });

    tearDownAll(() async {
      await server.close();
    });

    test(
        'top.start',
        () => resty
            .get('/hello')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello!'));

    test(
        'top.end',
        () => resty
            .get('/hello1')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'Hello1!'));

    test(
        'Intercept',
        () => resty
            .get('/api/sub/intercept')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '25'));

    test(
        'Include.TopIntercept',
        () => resty
            .get('/sub1/intercept')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '25'));

    test(
        'Include.TopIntercept.BottomIntercept',
        () => resty
            .get('/sub1/intercept1')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '50'));

    test(
        'Include.TopIntercept.ProgAfter',
        () => resty
            .get('/sub1/progaft')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '50'));

    test(
        'Include.TopIntercept.ClassIntercept',
        () => resty
            .get('/sub2/intercept')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '50'));

    test(
        'Include.TopIntercept.ClassIntercept.BottomIntercept',
        () => resty
            .get('/sub2/intercept1')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: '60'));

    test(
        'Get',
        () => resty
            .get('/api/sub')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'Get'));

    test(
        'Post',
        () => resty
            .post('/api/sub')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'Post'));

    test(
        'Put',
        () => resty
            .put('/api/sub')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'Put'));

    test(
        'Delete',
        () => resty
            .delete('/api/sub')
            .origin('http://localhost:10000')
            .exact(statusCode: 200, mimeType: 'text/plain', body: 'Delete'));

    test(
        'GetJson',
        () => resty.get('/api/sub/json').origin('http://localhost:10000').exact(
            statusCode: 200,
            mimeType: 'application/json',
            body: '{"method":"get"}'));

    test('PostJson', () async {
      await resty.post('/api/sub/json').origin('http://localhost:10000').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"post"}');
    });

    test('PutJson', () async {
      await resty.put('/api/sub/json').origin('http://localhost:10000').exact(
          statusCode: 200,
          mimeType: 'application/json',
          body: '{"method":"put"}');
    });

    test('DeleteJson', () async {
      await resty
          .delete('/api/sub/json')
          .origin('http://localhost:10000')
          .exact(
              statusCode: 200,
              mimeType: 'application/json',
              body: '{"method":"delete"}');
    });

    test('Exception1', () async {
      await resty
          .get('/sub1/except')
          .origin('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'except1');
    });

    test('Exception2', () async {
      await resty
          .get('/sub2/except')
          .origin('http://localhost:10000')
          .exact(statusCode: 200, mimeType: 'text/plain', body: 'except1');
    });
  });
}
