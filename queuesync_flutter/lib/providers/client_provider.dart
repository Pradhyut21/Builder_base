import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:queuesync_client/queuesync_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// The Serverpod client — singleton for the whole app.
///
/// In Serverpod 3.4, auth state is managed internally by the auth IDP widgets
/// (EmailSignInWidget) and stored in flutter_secure_storage automatically.
/// No explicit authenticationKeyManager is needed.
final clientProvider = Provider<Client>((ref) {
  return Client('http://localhost:8080/')
    ..connectivityMonitor = FlutterConnectivityMonitor();
});
