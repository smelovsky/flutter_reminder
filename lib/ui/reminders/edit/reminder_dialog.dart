import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminder/ui/reminders/edit/reminder_dialog_bloc.dart';
import 'package:intl/intl.dart' as intl;
import 'package:intl/intl.dart';
import '../../../db/models/reminder_item.dart';
import '../../users/user_dialog.dart';

class ReminderDialog extends StatefulWidget {
  final ValueChanged<ReminderItem> onFinish;

  final int id;
  final String reminderName;
  final String userName;
  final String userEmail;
  final String userPictureLage;
  final String userPictureThumbnail;
  final String reminderDate;
  final String reminderTime;

  const ReminderDialog({
    Key? key,
    required this.id,
    required this.reminderName,
    required this.onFinish,
    required this.userName,
    required this.userEmail,
    required this.userPictureLage,
    required this.userPictureThumbnail,
    required this.reminderDate,
    required this.reminderTime,
  }) : super(key: key);

  final String restorationId = 'password_field';

  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> with RestorationMixin {
  ReminderDialogBloc? _userDialogBloc;

  TextEditingController? _reminderNameTextEditingController;

  String reminderName = "";
  String userName = "";
  String userEmail = "";
  String userPictureLage = "";
  String userPictureThumbnail = "";
  String reminderDate = "";
  String reminderTime = "";

  var editMode = false;

  final RestorableBool _obscureText = RestorableBool(true);

  DateTime _DateTime = DateTime.now();
  TimeOfDay _TimeOfDay = TimeOfDay.now();

  @override
  void dispose() {
    _reminderNameTextEditingController?.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _reminderNameTextEditingController =
        TextEditingController(text: widget.reminderName);

    userName = widget.userName;
    reminderName = widget.reminderName;
    userEmail = widget.userEmail;
    userPictureLage = widget.userPictureLage;
    userPictureThumbnail = widget.userPictureThumbnail;
    reminderDate = widget.reminderDate;
    reminderTime = widget.reminderTime;

    if (userName.isNotEmpty) editMode = true;

    var dateTime;

    if (editMode) {
      if (reminderTime.isNotEmpty) {
        DateFormat format = DateFormat("MM/dd/yyyy hh:mm");
        dateTime = format.parse("${reminderDate} ${reminderTime}");
      } else {
        DateFormat format = DateFormat("MM/dd/yyyy");
        dateTime = format.parse("${reminderDate}");
      }

      if (dateTime != null) {
        _DateTime = dateTime;
        _TimeOfDay = TimeOfDay(hour: dateTime.hour, minute: dateTime.minute);
      }
    }

    _userDialogBloc = BlocProvider.of<ReminderDialogBloc>(context);
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    final _node = FocusScope.of(context);

    return BlocConsumer<ReminderDialogBloc, ReminderDialogState>(
      bloc: _userDialogBloc,
      listener: (BuildContext context, ReminderDialogState usersState) {},
      builder: (context, usersDialogScreenState) {
        return AlertDialog(
          title: (editMode)
              ? Text("Reminder (edit mode)")
              : Text("Reminder (new)"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                  controller: _reminderNameTextEditingController,
                  decoration: const InputDecoration(
                    alignLabelWithHint: true,
                    labelText: "Reminder name*",
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (value) {
                    setState(() {
                      reminderName = value;
                    });
                  },
                  onEditingComplete: () {
                    _node.unfocus();
                  },
                  onTapOutside: (PointerDownEvent event) {
                    FocusManager.instance.primaryFocus?.unfocus();
                  }),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (_) => UserListDialog(onFinish: (user) {
                        setState(() {
                          userName =
                              "${user.results.name.first} ${user.results.name.last}";
                          userEmail = user.results.email;
                          userPictureLage = user.results.picture.large;
                          userPictureThumbnail = user.results.picture.thumbnail;
                        });
                      }),
                    );
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Random user*"),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                            child: Text("${userName}\n${userEmail}"),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ]),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      print("_DateTime: ${_DateTime}");
                      var newDate = await showDatePicker(
                        context: context,
                        initialDate: _DateTime,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (newDate != null) {
                        setState(() {
                          reminderDate = intl.DateFormat.yMd().format(newDate);

                          DateFormat format = DateFormat("MM/dd/yyyy");
                          var dateTime = format.parse(reminderDate);

                          if (dateTime != null) {
                            _DateTime = dateTime;
                          }
                        });
                      }
                    },
                    child: Container(
                      child: Column(children: [
                        Text("Date"),
                        Container(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                            child: Text(reminderDate),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ]),
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(left: 50)),
                  GestureDetector(
                    onTap: () async {
                      var newTime = await showTimePicker(
                        context: context,
                        initialTime: _TimeOfDay,
                        initialEntryMode: TimePickerEntryMode.dial,
                        orientation: Orientation.portrait,
                      );

                      if (newTime != null) {
                        setState(() {
                          reminderTime = newTime.format(context);

                          var hour = int.parse(reminderTime.split(':')[0]);
                          var minute = int.parse(reminderTime.split(":")[1]);
                          _TimeOfDay = TimeOfDay(hour: hour, minute: minute);
                        });
                      }
                    },
                    child: Container(
                      child: Column(children: [
                        Text("Time"),
                        Container(
                          width: 100,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                            child: Text(reminderTime),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ]),
                    ),
                  ),
                ],
              ),
              //),
              if (userPictureLage.isNotEmpty)
                //Expanded(
                Flexible(
                    child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 8.0),
                  child: Image.network(userPictureLage),
                )),
            ],
          ),
          actions: <Widget>[
            if (reminderName.isNotEmpty &&
                reminderDate.isNotEmpty &&
                userName.isNotEmpty)
              TextButton(
                child: const Text("Save"),
                onPressed: () {
                  widget.onFinish(ReminderItem(
                    id: widget.id,
                    title: reminderName,
                    name: userName,
                    email: userEmail,
                    picture_large: userPictureLage,
                    picture_thumbnail: userPictureThumbnail,
                    date: reminderDate,
                    time: reminderTime,
                    is_selected: 0,
                    is_notified: 0,
                  ));
                  Navigator.of(context).pop();
                },
              ),
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    //);
  }
}
