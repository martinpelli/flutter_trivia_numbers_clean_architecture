import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_trivia_numbers_celan_architecture/core/network/network_info.dart';
import 'package:mocktail/mocktail.dart';
import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  late final MockDataConnectionChecker mockDataConnectionChecker;
  late final NetworkInfoImpl networkInfo;

  setUp(() {
    mockDataConnectionChecker = MockDataConnectionChecker();
    networkInfo = NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward the call to DataConnectionChecker.hasConnection', () async {
      //arrange
      final testHasConnectionFuture = Future.value(true);

      when(() => mockDataConnectionChecker.hasConnection).thenAnswer((_) => testHasConnectionFuture);
      //act
      final result = networkInfo.isConnected;
      //assert
      verify(() => mockDataConnectionChecker.hasConnection);
      expect(result, testHasConnectionFuture);
    });
  });
}
