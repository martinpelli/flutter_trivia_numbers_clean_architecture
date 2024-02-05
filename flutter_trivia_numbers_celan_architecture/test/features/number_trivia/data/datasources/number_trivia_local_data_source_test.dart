import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/error/exceptions.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/data/models/number_trivida_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late final MockSharedPreferences mockSharedPreferences;
  late final SharedPreferenceNumberTriviaLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = SharedPreferenceNumberTriviaLocalDataSource(sharedPreferences: mockSharedPreferences);
  });

  group('getLastNumberTrivia', () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));
    test('should return NumberTrivia from SharedPreferences when there is one in the cache', () async {
      //arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(fixture('trivia_cache.json'));
      //act
      final result = await dataSource.getLastNumberTrivia();
      //assert
      verify(() => mockSharedPreferences.getString(cachedNumberTrivia));
      expect(result, equals(tNumberTriviaModel));
    });

    test('should return CacheException when there is not a cached value', () async {
      //arrange
      when(() => mockSharedPreferences.getString(any())).thenReturn(null);
      //act
      final call = dataSource.getLastNumberTrivia;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    const tNumberTriviaModel = NumberTriviaModel(text: 'test trivia', number: 1);
    test('should call SharedPreferences to cache the data', () async {
      // Arrange
      when(() => mockSharedPreferences.setString(any(), any())).thenAnswer((_) => Future.value(true));
      //act
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      //assert
      final expectedJsonString = json.encode(tNumberTriviaModel.toJson());
      verify(() => mockSharedPreferences.setString(cachedNumberTrivia, expectedJsonString));
    });
  });
}
