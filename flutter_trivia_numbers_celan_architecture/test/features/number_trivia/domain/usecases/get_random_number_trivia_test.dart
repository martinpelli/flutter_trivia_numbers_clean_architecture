import 'package:flutter_trivia_numbers_celan_architecture/core/usecases/usecase.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/usecases/get_Random_number_trivia.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/entities/number_trivia.dart';

import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late final GetRandomNumberTrivia usecase;
  late final MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  const tNumberTrivia = NumberTrivia(number: 1, text: 'test');

  test('should get trivia from the repossitory', () async {
    //arrange
    when(() => mockNumberTriviaRepository.getRandomNumberTrivia()).thenAnswer((_) async => (null, tNumberTrivia));
    //act
    final result = await usecase(NoParams());
    //assert
    expect(result, (null, tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
