import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/app_models.dart';

/// Provider singleton de la base Isar.
final isarProvider = FutureProvider<Isar>((ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return Isar.open(
    [UserConfigSchema, MediaHistorySchema, AudioPreferencesSchema],
    directory: dir.path,
    name: 'somni_script',
  );
});
