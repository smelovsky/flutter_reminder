part of 'user_dialog_bloc.dart';

@immutable
abstract class UserDialogEvent {}

class ConnectUserDialogEvent extends UserDialogEvent {
  String host;

  ConnectUserDialogEvent({required this.host});

  @override
  String toString() => 'UserDialogEvent { }';
}

class AbortUserDialogEvent extends UserDialogEvent {
  @override
  String toString() => 'AbortUserDialogEvent { }';
}
