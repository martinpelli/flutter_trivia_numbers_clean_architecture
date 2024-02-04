import 'package:flutter_trivia_numbers_celan_architecture/core/error/exceptions.dart';
import 'package:flutter_trivia_numbers_celan_architecture/features/number_trivia/data/models/number_trivida_model.dart';

import '../../../../core/network/network_info.dart';
import '../datasources/number_trivia_local_data_source.dart';
import '../datasources/number_trivia_remote_data_source.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/number_trivia.dart';
import '../../domain/repositories/number_trivia_repository.dart';

class NumberTriviaRepositoryImpl implements NumberTriviaRepository {
  final NumberTriviaRemoteDataSource remoteDataSource;
  final NumberTriviaLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  NumberTriviaRepositoryImpl({required this.remoteDataSource, required this.localDataSource, required this.networkInfo});
  @override
  Future<(Failure?, NumberTrivia?)> getConcreteNumberTrivia(int number) async {
    return await _getTrivia(() => remoteDataSource.getConcreteNumberTrivia(number));
  }

  @override
  Future<(Failure?, NumberTrivia?)> getRandomNumberTrivia() async {
    return await _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<(Failure?, NumberTrivia?)> _getTrivia(Future<NumberTriviaModel> Function() getConcreteOrRandom) async {
    if (await networkInfo.isConnected) {
      try {
        final remoteTrivia = await getConcreteOrRandom();
        localDataSource.cacheNumberTrivia(remoteTrivia);
        return (null, remoteTrivia);
      } on ServerException {
        return (ServerFailure(), null);
      }
    } else {
      try {
        final localTrivia = await localDataSource.getLastNumberTrivia();
        return (null, localTrivia);
      } on CacheException {
        return (CacheFailure(), null);
      }
    }
  }
}
