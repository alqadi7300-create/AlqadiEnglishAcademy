import 'local_storage_service.dart';

class SyncService {
  final LocalStorageService local;

  SyncService({
    LocalStorageService? local,
  }) : local = local ?? LocalStorageService();

  static const String queueKey = 'sync_queue_v1';

  Future<void> enqueue(
    String collection,
    String id,
    Map<String, dynamic> data,
  ) async {
    final current = await local.readJson(queueKey);

    final items = current?['items'] as List?;

    final queue = <Map<String, dynamic>>[
      if (items != null)
        ...items.map(
          (item) => Map<String, dynamic>.from(item as Map),
        ),
    ];

    queue.add({
      'collection': collection,
      'id': id,
      'data': data,
      'queuedAt': DateTime.now().toIso8601String(),
    });

    await local.saveJson(
      queueKey,
      {
        'items': queue,
      },
    );
  }

  Future<List<Map<String, dynamic>>> pending() async {
    final data = await local.readJson(queueKey);

    final items = data?['items'] as List?;

    if (items == null || items.isEmpty) {
      return <Map<String, dynamic>>[];
    }

    return items
        .map(
          (item) => Map<String, dynamic>.from(item as Map),
        )
        .toList();
  }

  Future<void> clear() async {
    await local.remove(queueKey);
  }
}
