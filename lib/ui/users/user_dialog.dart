import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_reminder/ui/users/user_dialog_bloc.dart';
import '../../freezed/responses/user_response.dart';

class UserListDialog extends StatefulWidget {
  final ValueChanged<UserResponse> onFinish;

  const UserListDialog({
    Key? key,
    required this.onFinish,
  }) : super(key: key);

  final String restorationId = 'password_field';

  @override
  _UserListDialogState createState() => _UserListDialogState();
}

class _UserListDialogState extends State<UserListDialog> with RestorationMixin {
  UserDialogBloc? _userDialogBloc;

  final RestorableBool _obscureText = RestorableBool(true);

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _userDialogBloc = BlocProvider.of<UserDialogBloc>(context);

    _userDialogBloc!.add(ConnectUserDialogEvent(
      host: "https://randomuser.me/",
    ));
  }

  @override
  String? get restorationId => widget.restorationId;

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_obscureText, 'obscure_text');
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserDialogBloc, UserDialogState>(
      bloc: _userDialogBloc,
      listener: (BuildContext context, UserDialogState userDialogState) {
        if (userDialogState.screenState == UserDialogScreenState.failed) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("Connection failed"), Icon(Icons.error)],
                ),
                backgroundColor: Colors.red,
              ),
            );
        } else {
          ScaffoldMessenger.of(context)..hideCurrentSnackBar();
        }
      },
      builder: (context, usersDialogScreenState) {
        return AlertDialog(
          title: const Text("List of users"),
          content: _xxx(usersDialogScreenState),
          actions: <Widget>[
            TextButton(
              child: const Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
    //);
  }

  Widget _xxx(UserDialogState userDialogState) {
    switch (userDialogState.screenState) {
      case UserDialogScreenState.initial:
      case UserDialogScreenState.aborted:
      case UserDialogScreenState.failed:
        return _initialScreenUsers();

      case UserDialogScreenState.inprogress:
        return _inprogressScreenUsers();

      case UserDialogScreenState.success:
        return _successUsers(userDialogState.list);

      default:
        return Container();
    }
  }

  Widget _initialScreenUsers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        children: [Text("")],
      ),
    );
  }

  Widget _inprogressScreenUsers() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: CircularProgressIndicator(),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Connecting...'),
          ),
          //ElevatedButton(
          //  child: Text('Abort'),
          //  onPressed: () {
          //    _userDialogBloc?.add(AbortUserDialogEvent());
          //  },
          //)
        ],
      ),
    );
  }

  Widget _successUsers(List<UserResponse> list) {
    if (list.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4.0),
        child: Center(
          child: Text("No users"),
        ),
      );
    } else {
      return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4.0),
          child: Center(
              child: Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                      onTap: () {
                        print("user: ${index}");
                        widget.onFinish(list[index]);
                        Navigator.of(context).pop();
                      },
                      child: _userItem(list[index]));
                }),
          )));
    }
  }

  Widget _userItem(UserResponse userResponse) {
    return Row(children: [
      Image.network(userResponse.results.picture.thumbnail),
      Flexible(
          child: Container(
        padding: EdgeInsets.all(10),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "${userResponse.results.name.first}, ${userResponse.results.name.last}",
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            "${userResponse.results.email}",
            overflow: TextOverflow.ellipsis,
          ),
        ]),
      )),
    ]);
  }
}
