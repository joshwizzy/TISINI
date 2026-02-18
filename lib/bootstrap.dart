import 'dart:async';

import 'package:drift/native.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tisini/core/providers/core_providers.dart';
import 'package:tisini/core/storage/database/app_database.dart';
import 'package:tisini/core/storage/preferences.dart';

Future<void> bootstrap(
  FutureOr<Widget> Function(List<Override> overrides) builder,
) async {
  WidgetsFlutterBinding.ensureInitialized();

  final sharedPrefs = await SharedPreferences.getInstance();
  final preferences = Preferences(prefs: sharedPrefs);
  final database = AppDatabase(NativeDatabase.memory());

  final overrides = <Override>[
    preferencesProvider.overrideWithValue(preferences),
    databaseProvider.overrideWithValue(database),
  ];

  runApp(await builder(overrides));
}
