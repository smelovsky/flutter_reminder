part of 'user_dialog_bloc.dart';

enum UserDialogScreenState {
  initial,
  success,
  inprogress,
  aborted,
  failed,
}

@immutable
class UserDialogState {
  final UserDialogScreenState screenState;
  final List<UserResponse> list;

  UserDialogState({
    required this.screenState,
    required this.list,
  });

  factory UserDialogState.initial() {
    return UserDialogState(
      screenState: UserDialogScreenState.initial,
      list: [],
    );
  }

  UserDialogState copyWithState({
    required UserDialogScreenState screenState,
  }) {
    return UserDialogState(
      screenState: screenState,
      list: [],
    );
  }

  UserDialogState copyWithStateAndList({
    required UserDialogScreenState screenState,
    required List<UserResponse> list,
  }) {
    return UserDialogState(
      screenState: screenState,
      list: list,
    );
  }
}
