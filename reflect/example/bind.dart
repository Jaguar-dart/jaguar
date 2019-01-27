import 'package:jaguar/jaguar.dart';
import 'package:jaguar_reflect/bind/bind.dart';

void function(Context ctx) {}

class SomeClass {
  void function(Context ctx) {}
}

main() {
  bind((Context ctx) {});
  bind(function);
  bind(SomeClass().function);
}
