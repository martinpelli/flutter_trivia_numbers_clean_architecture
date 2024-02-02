import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class MockNumberTriviaRepository extends Mock implements NumberTriviaRepository {}

void main() {
  late final GetConcreteNumberTrivia usecase;
  late final MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = MockNumberTriviaRepository();
    usecase = GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNumber = 1;
  final tNumberTrivia = NumberTrivia(number: tNumber, text: 'test');

  test('should get trivia for the number from the repossitory', () async {
    //arrange
    when(() => mockNumberTriviaRepository.getConcreteNumberTrivia(any())).thenAnswer((_) async => (null, tNumberTrivia));
    //act
    final result = await usecase.execute(number: tNumber);
    //assert
    expect(result, (null, tNumberTrivia));
    verify(() => mockNumberTriviaRepository.getConcreteNumberTrivia(tNumber));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
