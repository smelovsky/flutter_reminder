part of 'reminder_dialog_bloc.dart';

enum ReminderDialogScreenState {
  initial,
  success,
  inprogress,
  aborted,
  failed,
}

//@immutable
class ReminderDialogState {
  final ReminderDialogScreenState screenState;

  ReminderDialogState({
    required this.screenState,
  });

  factory ReminderDialogState.initial() {
    return ReminderDialogState(
      screenState: ReminderDialogScreenState.initial,
    );
  }

  ReminderDialogState copyWithState({
    required ReminderDialogScreenState screenState,
  }) {
    return ReminderDialogState(
      screenState: screenState,
    );
  }

  ReminderDialogState copyWithStateAndList({
    required ReminderDialogScreenState screenState,
  }) {
    return ReminderDialogState(
      screenState: screenState,
    );
  }
}
