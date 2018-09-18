/// Provides Jaguar interceptor for mongo
///
/// [MongoDb] interceptor shall be wrapped around routes to automatically connect
/// and release connection to a mongodb server every request.
///
/// Note: Fret not! MongoDb does not create and destroy new connection every
/// request. It just uses one from a pool of connections. This way, you wont be
/// over-loading mongodb server with infinite connections.
///
///     @Api(path: '/api')
///     class TodoApi {
///     	// Declare Mongo interceptor
///     	MongoDb mongoDb(Context ctx) => new MongoDb('mongodb://localhost:27017/test');
///
///     	@Get()
///     	@WrapOne(#mongoDb)  // Wrap the mongo interceptor around a route
///     	Future<String> fetchAll(Context ctx) async {
///     		// ...
///     	}
///     }
///
/// [MongoDb] interceptor injects the per-request [Db] connection into the
/// interceptor inputs of [Context].
///
/// The per-request [Db] connection can be obtained using [getInput] method of
/// the [Context].
///
///     @Get()
///     @WrapOne(#mongoDb)  // Wrap the mongo interceptor around a route
///     Future<String> fetchAll(Context ctx) async {
///     	// Get the Db instance from the interceptor
///     	final Db db = ctx.getInput(MongoDb);
///     	// Use Db to fetch Todo items
///     	final res = await (await db.collection('todo').find()).toList();
///     	return await JSON.encode(res);
///     }
library jaguar_mongo;

export 'src/interceptor.dart';
export 'src/manager.dart';
