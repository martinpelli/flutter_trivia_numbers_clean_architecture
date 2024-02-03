import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/data/models/number_trivida_model.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  const tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'Test Text');

  test('should be a sublclass of NumberTrivia entity', () async {
    //asset
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group("fromJson", () {
    test("should return a valid model when the JSON number is an integer", () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test("should return a valid model when the JSON number is regarded as a double", () async {
      //arrange
      final Map<String, dynamic> jsonMap = json.decode(fixture('trivia_double.json'));
      //act
      final result = NumberTriviaModel.fromJson(jsonMap);
      //assert
      expect(result, tNumberTriviaModel);
    });
  });

  group('toJson', () {
    test("should return a JSON map containing the proper data", () async {
      //arrange
      final result = tNumberTriviaModel.toJson();
      //assert
      final expectedMap = {"text": "Test Text", "number": 1};
      expect(result, expectedMap);
    });
  });
}
