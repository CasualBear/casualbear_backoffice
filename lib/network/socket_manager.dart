import 'dart:async';

import 'package:socket_io_client/socket_io_client.dart' as IO;

class DataPacket {
  final EventType eventType;
  final dynamic data;

  DataPacket(this.eventType, this.data);
}

class SocketManager {
  static final SocketManager _singleton = SocketManager._internal();
  late IO.Socket _socket;
  final StreamController<bool> _connectionStreamController =
      StreamController<bool>.broadcast();
  final StreamController<DataPacket> _dataStreamController =
      StreamController<DataPacket>.broadcast();

  // Getter for the message stream
  Stream<DataPacket> get dataStream => _dataStreamController.stream;

  // Getter for the connection stream
  Stream<bool> get connectionStream => _connectionStreamController.stream;

  factory SocketManager() {
    return _singleton;
  }

  SocketManager._internal() {
    _socket = IO.io("https://casuabearapi.herokuapp.com/", <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': true,
    });

    _socket.on('connect', (_) {
      print('Connected to server');
      _connectionStreamController.add(true);
    });

    _socket.onAny((event, data) {
      print('$event: $data');
      _dataStreamController
          .add(DataPacket(EventTypeValues.fromString(event), data));
    });

    _socket.on('disconnect', (_) {
      print('Disconnected from server');
      _connectionStreamController.add(false);
    });
  }

  void sendData(DataPacket dataPacket) {
    print('Sending data: ${dataPacket.data}');
    _socket.emit(dataPacket.eventType.value, [dataPacket.data]);
  }

  void close() {
    _socket.disconnect();
  }
}

enum EventType {
  joinTeamRoom,
  preGame,
  gameStarted,
  teamUpdated,
  zonesUpdated,
  gameTimeChanged,
  gameEnded,
  location,
  logout,
}

extension EventTypeValues on EventType {
  String get value {
    switch (this) {
      case EventType.joinTeamRoom:
        return 'joinTeamRoom';
      case EventType.preGame:
        return 'PreGame';
      case EventType.gameStarted:
        return 'GameStarted';
      case EventType.teamUpdated:
        return 'TeamUpdated';
      case EventType.gameEnded:
        return 'GameEnded';
      case EventType.zonesUpdated:
        return 'ZonesChanged';
      case EventType.gameTimeChanged:
        return 'GameTimeChanged';
      case EventType.location:
        return 'locationSaved';
      case EventType.logout:
        return 'TeamLogout';
    }
  }

  static EventType fromString(String value) {
    switch (value) {
      case 'joinTeamRoom':
        return EventType.joinTeamRoom;
      case 'PreGame':
        return EventType.preGame;
      case 'GameStarted':
        return EventType.gameStarted;
      case 'TeamUpdated':
        return EventType.teamUpdated;
      case 'GameEnded':
        return EventType.gameEnded;
      case 'ZonesChanged':
        return EventType.zonesUpdated;
      case 'GameTimeChanged':
        return EventType.gameTimeChanged;
      case 'locationSaved':
        return EventType.location;
      case 'TeamLogout':
        return EventType.logout;
      default:
        return EventType.joinTeamRoom;
    }
  }
}
