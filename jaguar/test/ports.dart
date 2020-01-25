library test.jaguar.ports;

import 'dart:math';

const _offset = 10000;
const _spread = 20000;
final _rnd = Random();
int get random => _offset + _rnd.nextInt(_spread);
