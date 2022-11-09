import 'package:flutter/material.dart';

class Constants {
  static const mobile = 0xEE;
  static const wifi = 0xFF;
  static const disconnected = 0xDD;
  static const unknown = 0xCC;
  static const eof = -0xFFFFFF;
}

enum Connection { mobile, wifi, disconnected, unknown, eof }

Connection intToConnection(int connectionId) {
  var connection = Connection.disconnected;
  switch (connectionId) {
    case Constants.mobile:
      connection = Connection.mobile;
      break;
    case Constants.wifi:
      connection = Connection.wifi;
      break;
    case Constants.disconnected:
      connection = Connection.disconnected;
      break;
    case Constants.unknown:
      connection = Connection.unknown;
      break;
    case Constants.eof:
      connection = Connection.eof;
      break;
  }

  return connection;
}

Color getColor(Connection connectionType) {
  Color color = Colors.red;
  switch (connectionType) {
    case Connection.mobile:
      color = Colors.green;
      break;
    case Connection.wifi:
      color = Colors.blue;
      break;
    case Connection.disconnected:
      color = Colors.red;
      break;
    case Connection.unknown:
      color = Colors.black;
      break;
    case Connection.eof:
      color = Colors.grey;
      break;
  }
  return color;
}
