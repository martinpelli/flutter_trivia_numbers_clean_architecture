import '../../../../core/error/failures.dart';
import '../entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<(Failure?, NumberTrivia?)> getConcreteNumberTrivia(int number);
  Future<(Failure?, NumberTrivia?)> getRandomNumberTrivia();
}
