import 'package:flutter_config/flutter_config.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:myanimelist_api/myanimelist_api.dart';

final clientProvider = FutureProvider<Client>((ref) async {
  Logger logger = Logger();
  String apiKey = FlutterConfig.get('MYANIMELIST_TOKEN');
  Client client = Client(apiKey != null ? apiKey : '');
  if (apiKey == null) {
    logger.w('MAL API Key could not be found. Make you you have it set in');
  }

  return client;
});