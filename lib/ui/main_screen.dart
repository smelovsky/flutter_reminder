import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_reminder/ui/reminders/reminders_screen.dart';
import 'package:flutter_reminder/ui/settings/app_settings.dart';
import 'package:flutter_reminder/ui/settings/settings_screen.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../main.dart';
import 'about/about_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with TickerProviderStateMixin {
  late final TabController _tabController;

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();

    _prefs.then((SharedPreferences prefs) {
      final themeIsLight = prefs.getBool('theme') ?? true;
      AppSettings.themeIsLight.value = themeIsLight;

      final keepScreenOn = prefs.getBool('keep_screen_on') ?? true;
      Provider.of<AppState>(context, listen: false).keepScreenOn = keepScreenOn;

      if (keepScreenOn) {
        KeepScreenOn.turnOn();
      } else {
        KeepScreenOn.turnOff();
      }
    });

    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Reminder App"),
          actions: [
            IconButton(icon: Icon(Icons.exit_to_app), onPressed: () => exit(0)),
          ],
          bottom: TabBar(
            controller: _tabController,
            isScrollable: true,
            tabs: [
              Tab(text: "About"),
              Tab(text: "Settings"),
              Tab(text: "Reminders"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            AboutPage(),
            SettingsScreen(),
            RemindersScreen.create(),
          ],
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
