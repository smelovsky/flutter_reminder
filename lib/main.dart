import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminder/ui/core/bloc_observer.dart';
import 'package:flutter_reminder/ui/reminder_app.dart';
import 'package:provider/provider.dart';

import 'db/services/database.dart';

//@immutable
class AppState {
  AppState({
    required this.keepScreenOn,
  });

  bool keepScreenOn = true;
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await DB.instance.init();

  final _appState = AppState(
    keepScreenOn: true,
  );

  Bloc.observer = AppBlocObserver();

  runApp(MultiProvider(
    providers: [
      Provider.value(value: _appState),
    ],
    child: ReminderApp(),
  ));
}
