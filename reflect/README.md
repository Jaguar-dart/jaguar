# jaguar_reflect

Uses reflection instead of source generation to serve Jaguar Api classes.

## Usage

A simple usage example:

```dart
final book = new Book.make('0', 'Book1', ['Author1', 'Author2']);

@Api(path: '/api/book')
class BooksApi {
  @Get()
  Response<String> addBook(Context ctx) => Response.json(book.toMap());
}

Future<Null> main(List<String> args) async {
  final jaguar = new Jaguar(port: 8005);
  jaguar.addApi(reflect(new BooksApi()));
  await jaguar.serve();
}
```
