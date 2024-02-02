import 'package:flutter_trivia_numbers_celan_architecture/core/error/failures.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  Future<(Failure?, NumberTrivia?)> execute({required int number}) async {
    return await repository.getConcreteNumberTrivia(number);
  }
}
