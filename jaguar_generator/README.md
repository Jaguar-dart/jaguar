# jaguar-generator

Generates `RequestHandler` for a given Api class.

# Usage

## Api class

**lib/api.dart**:

```dart
import 'package:jaguar/jaguar.dart';

part 'api.g.dart';

/// Example of basic API class
@Api(path: '/api')
class MotherGroup extends _$JaguarMotherGroup {
  /// Example of basic route
  @Route(path: '/ping')
  String ping(Context ctx) => "You pinged me!";
}
```

## build.yaml settings

```yaml

```