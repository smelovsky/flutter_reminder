import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_reminder/ui/reminders/edit/reminder_dialog.dart';
import 'package:flutter_reminder/ui/reminders/reminder_item_widget.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../db/models/reminder_item.dart';
import '../../db/services/reminder_data_service.dart';
import '../../main.dart';
import 'package:timezone/timezone.dart' as tz;

class _ModelState {
  final List<ReminderItem> items;

  _ModelState({
    this.items = const <ReminderItem>[],
  });

  _ModelState copyWith({
    List<ReminderItem>? items,
  }) {
    return _ModelState(
      items: items ?? this.items,
    );
  }
}

class _ViewModel extends ChangeNotifier {
  final _dataService = ReminderDataService();

  var _state = _ModelState();
  _ModelState get state => _state;
  set state(_ModelState val) {
    _state = _state.copyWith(items: val.items);
    notifyListeners();
  }

  _ViewModel() {
    _asyncInit();
  }

  _asyncInit() async {
    var reminderItems = await _dataService.getReminderList();
    state = state.copyWith(items: reminderItems);
  }

  addItem(ReminderItem item) async {
    await _dataService.insertReminderItem(item);
    await _asyncInit();
  }

  updateItem(ReminderItem item) async {
    await _dataService.createUpdateReminderItem(item);
    await _asyncInit();
  }

  deleteItem(ReminderItem item) async {
    await _dataService.deleteReminderItem(item.id);

    await _asyncInit();
  }

  toggleItem(ReminderItem item) async {
    var new_item = (item.is_selected == 0)
        ? item.copyWith(is_selected: 1)
        : item.copyWith(is_selected: 0);

    await _dataService.unselectAllReminderItems();
    await _dataService.updateReminderItem(new_item);

    print("toggleItem: item: ${item.id} ");

    await _asyncInit();
  }

  Future<void> scheduleNotification(int seconds, int reminderId, String date,
      String time, String name) async {
    if (seconds > 0) {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          reminderId,
          'You have a meeting (${date}, ${date}) with',
          name,
          tz.TZDateTime.now(tz.local).add(Duration(seconds: seconds)),
          const NotificationDetails(
              android: AndroidNotificationDetails('channel id', 'channel name',
                  channelDescription: 'channel description')),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: "${reminderId}");
    } else {
      const AndroidNotificationDetails androidNotificationDetails =
          AndroidNotificationDetails('channel id', 'channel name',
              channelDescription: 'channel description',
              importance: Importance.max,
              priority: Priority.high,
              ticker: 'ticker');
      const NotificationDetails notificationDetails =
          NotificationDetails(android: androidNotificationDetails);
      await flutterLocalNotificationsPlugin.show(
          reminderId,
          'You have a meeting (${date}, ${date}) with',
          name,
          notificationDetails,
          payload: "${reminderId}");
    }
  }
}

class RemindersScreen extends StatelessWidget {
  const RemindersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<_ViewModel>();

    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, int index) => ReminderItemWidget(
          item: viewModel.state.items[index],
          onDelete: viewModel.deleteItem,
          onToggle: viewModel.toggleItem,
          onSave: (reminderItem) {
            viewModel.updateItem(reminderItem);
            if (reminderItem.time.isNotEmpty) {
              var seconds = getDuration(reminderItem.date, reminderItem.time);
              if (seconds >= 0) {
                print("reminderItem.id: ${reminderItem.id}");
                viewModel.scheduleNotification(seconds, reminderItem.id,
                    reminderItem.date, reminderItem.time, reminderItem.name);
              }
            }
          },
        ),
        itemCount: viewModel.state.items.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => ReminderDialog(
                id: 0,
                reminderName: "",
                userName: "",
                userEmail: "",
                userPictureLage: "",
                userPictureThumbnail: "",
                reminderDate: "",
                reminderTime: "",
                onFinish: (reminderItem) {
                  viewModel.addItem(reminderItem);
                  if (reminderItem.time.isNotEmpty) {
                    var seconds =
                        getDuration(reminderItem.date, reminderItem.time);
                    if (seconds >= 0) {
                      viewModel.scheduleNotification(
                          seconds,
                          reminderItem.id,
                          reminderItem.date,
                          reminderItem.time,
                          reminderItem.name);
                    }
                  }
                }),
          );
        },
        tooltip: 'Add Reminder',
        child: const Icon(Icons.add),
      ),
    );
  }

  static Widget create() => ChangeNotifierProvider(
        create: (_) => _ViewModel(),
        child: const RemindersScreen(),
      );
}

int getDuration(String date, String time) {
  DateFormat format = DateFormat("MM/dd/yyyy hh:mm");
  var dateTime = format.parse("${date} ${time}}");
  var difference = 0.0;

  if (dateTime != null) {
    DateTime dateTimeNow = new DateTime.now();
    DateTime dateTimeReminder = dateTime;

    difference = dateTimeReminder.difference(dateTimeNow).inMilliseconds / 1000;
    if (difference > 3600) {
      difference -= 3600;
    } else if (difference > 0) {
      difference = 0;
    }

    print(
        "dateTimeNow: ${dateTimeNow}, dateTimeReminder${dateTimeReminder}, difference: ${difference}");
  }

  return difference.toInt();
}
