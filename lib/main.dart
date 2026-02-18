import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tisini/app.dart';
import 'package:tisini/bootstrap.dart';

void main() {
  bootstrap(
    (overrides) =>
        ProviderScope(overrides: overrides, child: const TisiniApp()),
  );
}
