import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminder/ui/reminders/edit/reminder_dialog_bloc.dart';
import 'package:flutter_reminder/ui/settings/app_settings.dart';
import 'package:flutter_reminder/ui/users/user_dialog_bloc.dart';
import '../theme/app_theme.dart';
import 'main_screen.dart';

class ReminderApp extends StatefulWidget {
  const ReminderApp({Key? key}) : super(key: key);

  @override
  State<ReminderApp> createState() => _ReminderAppState();
}

class _ReminderAppState extends State<ReminderApp> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
        valueListenable: AppSettings.themeIsLight,
        builder: (_, isLight, __) => MultiBlocProvider(
              providers: [
                //BlocProvider<UsersBloc>(create: (context) => UsersBloc()),
                BlocProvider<UserDialogBloc>(
                    create: (context) => UserDialogBloc()),
                BlocProvider<ReminderDialogBloc>(
                    create: (context) => ReminderDialogBloc()),
              ],
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: isLight ? AppTheme.lightTheme : AppTheme.darkTheme,
                home: MainScreen(),
              ),
            ));
  }
}
