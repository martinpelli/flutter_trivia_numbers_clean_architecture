import 'package:equatable/equatable.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/error/failures.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/usecases/usecase.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import '../repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, Params> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<(Failure?, NumberTrivia?)> call(Params params) async {
    return await repository.getConcreteNumberTrivia(params.number);
  }
}

class Params extends Equatable {
  final int number;

  const Params({required this.number});

  @override
  List<Object?> get props => [number];
}
