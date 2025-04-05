import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  Future<bool> isConnected() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  Stream<bool> get onConnectivityChanged {
    return Connectivity().onConnectivityChanged.map(
          (result) => result != ConnectivityResult.none,
        );
  }
}