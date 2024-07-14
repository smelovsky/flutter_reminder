import 'package:flutter_reminder/db/db_model.dart';

import '../models/reminder_item.dart';
import 'database.dart';

class ReminderDataService {
  Future createUpdateReminderItem(ReminderItem item) async {
    await DB.instance.createUpdate(item);
  }

  Future insertReminderItem(ReminderItem item) async {
    var id = await DB.instance.add(item);
    print("insertReminderItem: id=${id}");
  }

  Future<ReminderItem> getReminderItemById(int itemId) async {
    var res = await DB.instance.get<ReminderItem>(itemId);
    if (res != null) return res;
    throw Exception('Item not found');
  }

  Future deleteReminderItem(int id) async {
    var model = await DB.instance.get<ReminderItem>(id);
    if (model != null) {
      await DB.instance.delete(model);
    } else {
      throw Exception('Item not found');
    }
  }

  Future<List<ReminderItem>> getReminderList({
    int take = 10,
    int skip = 0,
  }) async {
    var items = await DB.instance.getAll<ReminderItem>(
      skip: skip,
      take: take,
    );

    return items.toList();
  }

  Future<ReminderItem?> getReminderById({int id = 0}) async {
    var item = await DB.instance.get<ReminderItem>(id);

    return item;
  }

  Future updateReminderItem(ReminderItem item) async {
    await DB.instance.createUpdate(item);
  }

  Future unselectAllReminderItems() async {
    await DB.instance.unselectAll<ReminderItem>();
  }
}
