import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reminder/ui/reminders/edit/reminder_dialog.dart';
import 'package:flutter_reminder/ui/reminders/reminder_item_widget.dart';
import 'package:provider/provider.dart';
import '../../db/models/reminder_item.dart';
import '../../db/services/reminder_data_service.dart';

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

  _updateItem(ReminderItem item) async {
    await _dataService.createUpdateReminderItem(item);
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
                onFinish: viewModel.addItem),
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
