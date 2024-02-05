import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/error/exceptions.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/data/models/number_trivida_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

class UriFake extends Fake implements Uri {}

void main() {
  late MockHttpClient mockHttpClient;
  late HttpClientNumberTriviaRemoteDataSource dataSource;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = HttpClientNumberTriviaRemoteDataSource(client: mockHttpClient);
    registerFallbackValue(UriFake());
  });

  void setUpMockHttpClienSuccess() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response(fixture('trivia.json'), 200));
  }

  void setUpMockHttpClientFailure() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer((_) async => http.Response('Something went wrong', 404));
  }

  group("getConcreteNumbertrivia", () {
    const tNumber = 1;
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number being the endpoint', () async {
      //arrange
      setUpMockHttpClienSuccess();
      //act
      dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/$tNumber'), headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      //arrange
      setUpMockHttpClienSuccess();
      //act
      final result = await dataSource.getConcreteNumberTrivia(tNumber);
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw a ServerException when the response code is not 200 (unsuccessful)', () async {
      //arrange
      setUpMockHttpClientFailure();
      //act
      final call = dataSource.getConcreteNumberTrivia;
      //assert
      expect(() => call(tNumber), throwsA(const TypeMatcher<ServerException>()));
    });
  });

  group("getRandomNumbertrivia", () {
    final tNumberTriviaModel = NumberTriviaModel.fromJson(json.decode(fixture('trivia.json')));

    test('should perform a GET request on a URL with number ', () async {
      //arrange
      setUpMockHttpClienSuccess();
      //act
      dataSource.getRandomNumberTrivia();
      //assert
      verify(() => mockHttpClient.get(Uri.parse('http://numbersapi.com/random'), headers: {'Content-Type': 'application/json'}));
    });

    test('should return NumberTrivia when the response code is 200 (success)', () async {
      //arrange
      setUpMockHttpClienSuccess();
      //act
      final result = await dataSource.getRandomNumberTrivia();
      //assert
      expect(result, tNumberTriviaModel);
    });

    test('should throw a ServerException when the response code is not 200 (unsuccessful)', () async {
      //arrange
      setUpMockHttpClientFailure();
      //act
      final call = dataSource.getRandomNumberTrivia;
      //assert
      expect(() => call(), throwsA(const TypeMatcher<ServerException>()));
    });
  });
}
