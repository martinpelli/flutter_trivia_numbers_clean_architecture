import 'package:equatable/equatable.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/error/failures.dart';

abstract class UseCase<Type, Params> {
  Future<(Failure?, Type?)> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}
