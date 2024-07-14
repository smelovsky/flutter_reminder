import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../db/models/reminder_item.dart';
import 'edit/reminder_dialog.dart';

class ReminderItemWidget extends StatelessWidget {
  final ReminderItem item;
  final Function(ReminderItem) onDelete;
  final Function(ReminderItem) onToggle;
  final Function(ReminderItem) onSave;
  const ReminderItemWidget({
    Key? key,
    required this.item,
    required this.onDelete,
    required this.onToggle,
    required this.onSave,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (item.is_selected == 1) {
      return GestureDetector(
        onTap: () {
          print("item: id=${item.id}");
          onToggle(item);
        },
        child: Container(
            decoration: const BoxDecoration(
              border: Border(
                left: BorderSide(color: Color(0xFFFFFFFF)),
                right: BorderSide(color: Color(0xFFFFFFFF)),
                bottom: BorderSide(),
                top: BorderSide(),
              ),
            ),
            child: ListTile(
                title: Row(children: [
              Image.network(item.picture_large, height: 60),
              Expanded(
                  child: Container(
                padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 00.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${item.title}, ${item.date} ${item.time}",
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(0.8),
                      ),
                      Text(
                        "${item.name}",
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(0.8),
                      ),
                      Text(
                        "${item.email}",
                        overflow: TextOverflow.ellipsis,
                        textScaler: TextScaler.linear(0.8),
                      ),
                    ]),
              )),
              IconButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (_) => ReminderDialog(
                        id: item.id,
                        reminderName: item.title,
                        userName: item.name,
                        userEmail: item.email,
                        userPictureLage: item.picture_large,
                        userPictureThumbnail: item.picture_thumbnail,
                        reminderDate: item.date,
                        reminderTime: item.time,
                        onFinish: (reminderItem) {
                          onSave(reminderItem);
                        }),
                  );
                },
                icon: Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  //onDelete(item);
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text(
                              "Delete selected reminder?",
                              style: TextStyle(fontSize: 20),
                            ),
                            actions: [
                              TextButton(
                                child: Text("No"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text("Yes"),
                                onPressed: () {
                                  onDelete(item);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                },
                icon: Icon(Icons.delete),
              ),
            ]))),
      );
    } else {
      return GestureDetector(
        onTap: () {
          onToggle(item);
        },
        child: Container(
            child: ListTile(
                title: Row(children: [
          Image.network(item.picture_large, height: 60),
          Flexible(
              child: Container(
            padding: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 00.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                "${item.title}, ${item.date} ${item.time}",
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.linear(0.8),
              ),
              Text(
                "${item.name}",
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.linear(0.8),
              ),
              Text(
                "${item.email}",
                overflow: TextOverflow.ellipsis,
                textScaler: TextScaler.linear(0.8),
              ),
            ]),
          )),
        ]))),
      );
    }
  }
}
