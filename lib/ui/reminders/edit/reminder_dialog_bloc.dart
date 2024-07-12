import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';

part 'reminder_dialog_event.dart';
part 'reminder_dialog_state.dart';

class ReminderDialogBloc
    extends Bloc<ReminderDialogEvent, ReminderDialogState> {
  ReminderDialogBloc() : super(ReminderDialogState.initial()) {}

  @override
  Future<void> close() {
    return super.close();
  }
}
