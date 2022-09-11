import 'package:flutter_dotenv/flutter_dotenv.dart';

enum Env { FEATURE, DEV, STAGE, PROD }

enum FLAVOR { TEST }

class EnvironmentConfig {
  static const APP_NAME = String.fromEnvironment(
    'APP_NAME',
    defaultValue: "QCar",
  );
  static const FLAVOR = String.fromEnvironment('FLAVOR');
  static const ENV = String.fromEnvironment(
    'ENV',
    defaultValue: "DEV",
  );

  static String get domain => dotenv.env['Domain'] ?? "";
  static String get host => dotenv.env['Host'] ?? "";
  static int get port => int.parse((dotenv.env['Port'] ?? "88"));
  static String get user => dotenv.env['User'] ?? "";
  static String get pewe => dotenv.env['PeWe'] ?? "";
  static String get version => dotenv.env['Version'] ?? "0.0.7";
  static String get backendUrl => dotenv.env['BackendUrl'] ?? "";

  static bool get isDev => ENV == Env.DEV.name;
}
