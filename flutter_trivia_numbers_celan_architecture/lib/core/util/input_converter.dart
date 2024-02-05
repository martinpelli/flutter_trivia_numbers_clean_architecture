import 'package:flutter_trivia_numbers_celan_architecture/core/error/failures.dart';

class InputConverter {
  (Failure?, int?) stringToUnsignedInteger(String str) {
    try {
      final integer = int.parse(str);
      if (integer < 0) throw const FormatException();
      return (null, integer);
    } on FormatException {
      return (InvalidInputFailure(), null);
    }
  }
}

class InvalidInputFailure extends Failure {}
