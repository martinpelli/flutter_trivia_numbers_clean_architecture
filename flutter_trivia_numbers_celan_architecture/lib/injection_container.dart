import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';
import 'core/network/network_info.dart';
import 'core/util/input_converter.dart';
import 'features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'features/number_trivia/data/datasources/number_trivia_remote_data_source.dart';
import 'features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'features/number_trivia/domain/usecases/get_random_number_trivia.dart';
import 'features/number_trivia/presentation/bloc/number_trivia_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

final serviceLocator = GetIt.instance;

Future<void> init() async {
  //! Features - Number Trivia
  serviceLocator.registerFactory(
      () => NumberTriviaBloc(getConcreteNumberTrivia: serviceLocator(), getRandomNumberTrivia: serviceLocator(), inputConverter: serviceLocator()));

  serviceLocator.registerLazySingleton(() => GetConcreteNumberTrivia(serviceLocator()));
  serviceLocator.registerLazySingleton(() => GetRandomNumberTrivia(serviceLocator()));

  serviceLocator.registerLazySingleton<NumberTriviaRepository>(
      () => NumberTriviaRepositoryImpl(localDataSource: serviceLocator(), networkInfo: serviceLocator(), remoteDataSource: serviceLocator()));

  serviceLocator.registerLazySingleton<NumberTriviaRemoteDataSource>(() => HttpClientNumberTriviaRemoteDataSource(client: serviceLocator()));
  serviceLocator
      .registerLazySingleton<NumberTriviaLocalDataSource>(() => SharedPreferenceNumberTriviaLocalDataSource(sharedPreferences: serviceLocator()));

  //! Core
  serviceLocator.registerLazySingleton(() => InputConverter());
  serviceLocator.registerLazySingleton<NetworkInfo>(() => DataConnectionCheckerNetworkInfo(serviceLocator()));

  //! External
  serviceLocator.registerLazySingletonAsync<SharedPreferences>(() async => await SharedPreferences.getInstance());
  serviceLocator.registerLazySingleton(() => (http.Client()));
  serviceLocator.registerLazySingleton(() => DataConnectionChecker());
}
