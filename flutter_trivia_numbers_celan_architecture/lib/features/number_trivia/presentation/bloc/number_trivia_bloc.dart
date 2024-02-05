import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/error/failures.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/usecases/usecase.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/util/input_converter.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';

part 'number_trivia_event.dart';
part 'number_trivia_state.dart';

const String serverFailureMessage = 'Server Failure';
const String cacheFailureMessage = 'Cache Failure';
const String invalidInputFailureMessage = 'Invalid Input - The Number must be a positive integer or zero';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;
  NumberTriviaBloc({required this.getConcreteNumberTrivia, required this.getRandomNumberTrivia, required this.inputConverter}) : super(Empty()) {
    on<GetTriviaForConcreteNumber>(_getTriviaForConcreteNumber);

    on<GetTriviaForRandomNumber>(_getTriviaForRandomNumber);
  }

  FutureOr<void> _getTriviaForConcreteNumber(GetTriviaForConcreteNumber event, Emitter<NumberTriviaState> emit) async {
    final (converterFailure, integer) = inputConverter.stringToUnsignedInteger(event.numberString);

    if (converterFailure != null) {
      emit(const Error(message: invalidInputFailureMessage));
      return null;
    }

    emit(Loading());

    final (useCaseFailure, numberTrivia) = await getConcreteNumberTrivia(Params(number: integer!));

    if (useCaseFailure != null) {
      emit(Error(message: _mapFailureToMessage(useCaseFailure)));
      return null;
    }

    emit(Loaded(trivia: numberTrivia!));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return serverFailureMessage;
      case CacheFailure:
        return cacheFailureMessage;
      default:
        return 'Unexpected error';
    }
  }

  FutureOr<void> _getTriviaForRandomNumber(GetTriviaForRandomNumber event, Emitter<NumberTriviaState> emit) async {
    emit(Loading());

    final (useCaseFailure, numberTrivia) = await getRandomNumberTrivia(NoParams());

    if (useCaseFailure != null) {
      emit(Error(message: _mapFailureToMessage(useCaseFailure)));
      return null;
    }

    emit(Loaded(trivia: numberTrivia!));
  }
}
