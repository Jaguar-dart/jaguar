import 'dart:html';

main() {
  final DivElement messageDiv = querySelector('#message') as DivElement;
  messageDiv.text = "hello";
}
