import 'package:drift/drift.dart';

part 'app_database.g.dart';

class CachedTransactions extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  TextColumn get direction => text()();
  TextColumn get status => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text()();
  TextColumn get counterpartyName => text()();
  TextColumn get counterpartyIdentifier => text()();
  TextColumn get category => text()();
  TextColumn get merchantRole => text().nullable()();
  TextColumn get note => text().nullable()();
  TextColumn get rail => text()();
  IntColumn get fee => integer()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedPayees extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get identifier => text()();
  TextColumn get rail => text()();
  TextColumn get avatarUrl => text().nullable()();
  TextColumn get role => text().nullable()();
  BoolColumn get isPinned => boolean().withDefault(const Constant(false))();
  DateTimeColumn get lastPaidAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedPiaCards extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get what => text()();
  TextColumn get why => text()();
  TextColumn get details => text().nullable()();
  TextColumn get actionsJson => text()();
  TextColumn get priority => text()();
  TextColumn get status => text()();
  BoolColumn get isPinned => boolean()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

class CachedPensionContributions extends Table {
  TextColumn get id => text()();
  IntColumn get amount => integer()();
  TextColumn get currency => text()();
  TextColumn get status => text()();
  TextColumn get reference => text().nullable()();
  TextColumn get rail => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  DateTimeColumn get cachedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    CachedTransactions,
    CachedPayees,
    CachedPiaCards,
    CachedPensionContributions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
