import 'package:flutter/cupertino.dart';

@immutable
class AppState {
  AppState({
    required this.keepScreenOn,
  });

  bool keepScreenOn = true;
}
