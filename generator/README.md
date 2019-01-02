# jaguar-generator

Generates `Controller` installers.

# Usage

## Add build_runner dependencies:

**pubspec.yaml:**
```yaml
dependencies:
  jaguar:

dev_dependencies:
  build_runner:
  jaguar_generator:
```

## Declare Controller class

**lib/example.dart**:
```dart
import 'package:jaguar/jaguar.dart';

part 'example.jroutes.dart';

@GenController(path: "/simple")
class SimpleApi extends Controller with _$SimpleApi {
  @Get()
  String get(_) => "simple";
}
```

## Generate Controller installer

```bash
pub run build_runner build
```

A file named `lib/example.jroutes.dart` will be generated with Controller installer class `_$SimpleApi`.