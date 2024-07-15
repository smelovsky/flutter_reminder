import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../db/models/reminder_item.dart';
import '../db/services/reminder_data_service.dart';

class PreviewPage extends StatefulWidget {
  const PreviewPage(
    this.payload, {
    Key? key,
  }) : super(key: key);

  static const String routeName = '/previewPage';

  final String? payload;

  @override
  State<StatefulWidget> createState() => PreviewPageState();
}

class PreviewPageState extends State<PreviewPage> {
  String? _payload;

  String reminderName = "";
  String userName = "";
  String userEmail = "";
  String userPictureLage = "";
  String userPictureThumbnail = "";
  String reminderDate = "";
  String reminderTime = "";

  @override
  void initState() {
    super.initState();
    _payload = widget.payload;

    print("_payload: ${_payload}");

    int id = int.parse(_payload!);

    _asyncInit(id);
  }

  _asyncInit(int id) async {
    final _dataService = ReminderDataService();
    var reminderItem = await _dataService.getReminderById(id: id);

    setState(() {
      if (reminderItem != null) {
        reminderName = reminderItem.title;
        userName = reminderItem.name;
        userEmail = reminderItem.email;
        userPictureLage = reminderItem.picture_large;
        userPictureThumbnail = reminderItem.picture_thumbnail;
        reminderDate = reminderItem.date;
        reminderTime = reminderItem.time;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder (preview mode)'),
      ),
      body: Padding(
          padding: EdgeInsets.only(top: 40, bottom: 0, left: 10, right: 10),
          child: Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 4.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Reminder name"),
                        Container(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4.0, vertical: 4.0),
                            child: Text(reminderName),
                          ),
                          decoration: BoxDecoration(border: Border.all()),
                        ),
                      ]),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 4.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text("Random user"),
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 4.0, vertical: 4.0),
                  child: Row(children: [
                    Expanded(
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
                        flex: 1),
                    Expanded(
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
                        flex: 1),
                  ]),
                ),
                if (userPictureLage.isNotEmpty)
                  Flexible(
                      child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 0.0, vertical: 8.0),
                    child: Image.network(userPictureLage),
                  )),
              ],
            ),
          )),
    );
  }
}
