import 'dart:convert';

import 'package:flutter_trivia_numbers_celan_architecture/core/error/exceptions.dart';

import '../models/number_trivida_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/{number} endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class HttpClientNumberTriviaRemoteDataSource implements NumberTriviaRemoteDataSource {
  final http.Client client;

  HttpClientNumberTriviaRemoteDataSource({required this.client});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    return await _getTriviaFromUrl('$number');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromUrl('random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String path) async {
    final result = await client.get(Uri.parse('http://numbersapi.com/$path'), headers: {'Content-Type': 'application/json'});

    if (result.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(result.body));
    } else {
      throw ServerException();
    }
  }
}
