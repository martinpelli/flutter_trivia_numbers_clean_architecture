import 'package:data_connection_checker_nulls/data_connection_checker_nulls.dart';

abstract class NetworkInfo {
  Future<bool> get isConnected;
}

class DataConnectionCheckerNetworkInfo implements NetworkInfo {
  final DataConnectionChecker dataConnectionChecker;

  DataConnectionCheckerNetworkInfo(this.dataConnectionChecker);

  @override
  Future<bool> get isConnected => dataConnectionChecker.hasConnection;
}
