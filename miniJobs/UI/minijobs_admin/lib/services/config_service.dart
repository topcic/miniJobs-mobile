import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ConfigService {
  static final ConfigService _instance = ConfigService._internal();
  Map<String, dynamic>? _config;

  factory ConfigService() {
    return _instance;
  }

  ConfigService._internal();

  // Load the configuration file asynchronously
  Future<void> init() async {
    try {
      final String configString = await rootBundle.loadString('assets/config/config.json');
      _config = json.decode(configString) as Map<String, dynamic>;
    } catch (e) {
      print('Error loading config: $e');
      _config = {}; // Empty map as fallback if loading fails
    }
  }

  // Get baseUrl, prioritizing --dart-define over config file
  String getBaseUrl() {
    const String baseUrlFromEnv = String.fromEnvironment(
      'baseUrl',
      defaultValue: '',
    );
    return baseUrlFromEnv.isNotEmpty ? baseUrlFromEnv : _config?['baseUrl'] ?? '';
  }
}