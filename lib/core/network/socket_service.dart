import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class SocketService {
  IO.Socket? _socket;
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  IO.Socket? get socket => _socket;

  Future<void> connect() async {
    if (_socket != null) return;
    final token = await _storage.read(key: 'auth_token');
    final s = IO.io(
      ApiConstants.socketBase,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .setQuery({})
          .build(),
    );
    _socket = s;
    s.onConnect((_) async {
      if (token != null) {
        s.emit('auth', token);
      }
    });
  }

  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  void dispose() {
    _socket?.dispose();
    _socket = null;
  }
}

final socketService = SocketService();
