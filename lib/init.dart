import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:test_app/services/http/http_api.dart';


class Init {
  static Future initialize() async {
    initializeDateFormatting('ru');
    await _loadSettings();
    await _registerServices();
  }

  static _loadSettings() async {
    WidgetsFlutterBinding.ensureInitialized(); // Required by FlutterConfig
    await FlutterConfig.loadEnvVariables();
  }

  static _registerServices() async {
    GetIt getIt = GetIt.instance;

    getIt.registerSingleton<HttpApi>(HttpApi());
  }
}