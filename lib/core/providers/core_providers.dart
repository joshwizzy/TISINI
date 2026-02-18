import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/core/network/dio_client.dart';
import 'package:tisini/core/storage/database/app_database.dart';
import 'package:tisini/core/storage/preferences.dart';
import 'package:tisini/core/storage/secure_storage.dart';

final secureStorageProvider = Provider<SecureStorage>((ref) {
  return SecureStorage();
});

final preferencesProvider = Provider<Preferences>((ref) {
  // Will be overridden in bootstrap with actual SharedPreferences
  throw UnimplementedError('preferencesProvider must be overridden');
});

final dioProvider = Provider<Dio>((ref) {
  final secureStorage = ref.watch(secureStorageProvider);
  return DioClient(secureStorage: secureStorage).dio;
});

final databaseProvider = Provider<AppDatabase>((ref) {
  // Will be overridden in bootstrap with actual database
  throw UnimplementedError('databaseProvider must be overridden');
});
