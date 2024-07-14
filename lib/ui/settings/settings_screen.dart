import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:keep_screen_on/keep_screen_on.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app_state.dart';
import 'app_settings.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool keepScreenOn = true;

  @override
  void initState() {
    super.initState();

    keepScreenOn = Provider.of<AppState>(context, listen: false).keepScreenOn;
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _setTheme(bool themeIsLight) async {
    final SharedPreferences prefs = await _prefs;
    prefs.setBool('theme', themeIsLight);
  }

  Future<void> _setKeepScreenOn() {
    return Future.wait([
      KeepScreenOn.isOn,
      KeepScreenOn.isAllowLockWhileScreenOn,
    ]).then((values) async {
      final _isKeepScreenOn = values.elementAtOrNull(0) ?? false;
      final SharedPreferences prefs = await _prefs;
      prefs.setBool('keep_screen_on', _isKeepScreenOn);

      print("keep_screen_on ${_isKeepScreenOn}");
    });
  }

  @override
  Widget build(BuildContext context) {
    final _node = FocusScope.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Column(
          children: [
            ListTile(
              title: const Text('Dark theme'),
              trailing: CupertinoSwitch(
                value: isDark,
                onChanged: (value) {
                  _setTheme(!value);
                  AppSettings.themeIsLight.value = !value;
                },
              ),
            ),
            ListTile(
              title: const Text('Keep screen on'),
              trailing: CupertinoSwitch(
                value: keepScreenOn,
                onChanged: (value) {
                  Provider.of<AppState>(context, listen: false).keepScreenOn =
                      value;

                  if (value) {
                    KeepScreenOn.turnOn().then((value) => _setKeepScreenOn());
                  } else {
                    KeepScreenOn.turnOff().then((value) => _setKeepScreenOn());
                  }

                  setState(() {
                    keepScreenOn = value;
                  });
                },
              ),
            ),
          ],
        ));
  }
}
