part of 'reminder_dialog_bloc.dart';

@immutable
abstract class ReminderDialogEvent {}

class ConnectUserDialogEvent extends ReminderDialogEvent {
  @override
  String toString() => 'ReminderDialogEvent { }';
}

class AbortReminderDialogEvent extends ReminderDialogEvent {
  @override
  String toString() => 'AbortReminderDialogEvent { }';
}
