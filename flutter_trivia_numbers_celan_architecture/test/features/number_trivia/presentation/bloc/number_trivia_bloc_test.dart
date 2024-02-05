import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/error/failures.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/usecases/usecase.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/util/input_converter.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetConcreteNumberTrivia extends Mock implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

class ParamsFake extends Fake implements Params {}

class NoParamsFake extends Fake implements NoParams {}

void main() {
  late MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  late MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  late MockInputConverter mockInputConverter;
  late NumberTriviaBloc bloc;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();
    bloc = NumberTriviaBloc(
        getConcreteNumberTrivia: mockGetConcreteNumberTrivia, getRandomNumberTrivia: mockGetRandomNumberTrivia, inputConverter: mockInputConverter);
    registerFallbackValue(ParamsFake());
    registerFallbackValue(NoParamsFake());
  });

  group('GetTriviaForConcreteNumber', () {
    const tNumberString = '1';
    const tNumberParsed = 1;
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockInputConverterSuccess() => when(() => mockInputConverter.stringToUnsignedInteger(any())).thenReturn((null, tNumberParsed));
    void setUpMockGetConcreteNumberTriviaSuccess() => when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => (null, tNumberTrivia));

    blocTest<NumberTriviaBloc, NumberTriviaState>('should call the InputConverter to validate and convert rhe string to an unsigned integer',
        build: () {
          setUpMockInputConverterSuccess();
          setUpMockGetConcreteNumberTriviaSuccess();
          return bloc;
        },
        act: (bloc) async {
          bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString));
          await untilCalled(() => mockInputConverter.stringToUnsignedInteger(any()));
        },
        verify: (_) => verify(() => mockInputConverter.stringToUnsignedInteger(tNumberString)));

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Error when the input is invalid',
      build: () {
        when(() => mockInputConverter.stringToUnsignedInteger(any())).thenReturn((InvalidInputFailure(), null));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => const <NumberTriviaState>[Error(message: invalidInputFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString)),
      verify: (_) => mockGetConcreteNumberTrivia(const Params(number: tNumberParsed)),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Loading, Error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => (ServerFailure(), null));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => <NumberTriviaState>[Loading(), const Error(message: serverFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Loading, Loaded when getting data success',
      build: () {
        setUpMockInputConverterSuccess();
        setUpMockGetConcreteNumberTriviaSuccess();
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => <NumberTriviaState>[Loading(), const Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Loading, Error with a proper message fo the error when getting data fails',
      build: () {
        setUpMockInputConverterSuccess();
        when(() => mockGetConcreteNumberTrivia(any())).thenAnswer((_) async => (CacheFailure(), null));
        return bloc;
      },
      act: (bloc) => bloc.add(const GetTriviaForConcreteNumber(numberString: tNumberString)),
      expect: () => <NumberTriviaState>[Loading(), const Error(message: cacheFailureMessage)],
    );
  });

  group('GetTriviaForRandomNumber', () {
    const tNumberTrivia = NumberTrivia(number: 1, text: 'test trivia');

    void setUpMockGetRandomNumberTriviaSuccess() => when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => (null, tNumberTrivia));

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should get data from the concrete use case',
      build: () {
        setUpMockGetRandomNumberTriviaSuccess();
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      verify: (_) => mockGetRandomNumberTrivia(NoParams()),
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Loading, Error when getting data fails',
      build: () {
        when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => (ServerFailure(), null));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[Loading(), const Error(message: serverFailureMessage)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Loading, Loaded when getting data success',
      build: () {
        setUpMockGetRandomNumberTriviaSuccess();
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[Loading(), const Loaded(trivia: tNumberTrivia)],
    );

    blocTest<NumberTriviaBloc, NumberTriviaState>(
      'should emit Loading, Error with a proper message fo the error when getting data fails',
      build: () {
        when(() => mockGetRandomNumberTrivia(any())).thenAnswer((_) async => (CacheFailure(), null));
        return bloc;
      },
      act: (bloc) => bloc.add(GetTriviaForRandomNumber()),
      expect: () => <NumberTriviaState>[Loading(), const Error(message: cacheFailureMessage)],
    );
  });
}
