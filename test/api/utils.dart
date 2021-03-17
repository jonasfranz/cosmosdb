import 'dart:math';

import 'package:crypto/crypto.dart';

String generateDatabaseName() {
  final random = Random();
  var values = List<int>.generate(32, (i) => random.nextInt(256));
  return md5.convert(values).toString();
}
