import 'dart:async';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:cancellation_token/cancellation_token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import '../../freezed/dio_network_manager.dart';
import '../../freezed/requests/isolated_network_request.dart';
import '../../freezed/responses/user_response.dart';

part 'user_dialog_event.dart';
part 'user_dialog_state.dart';

class UserDialogBloc extends Bloc<UserDialogEvent, UserDialogState> {
  List<UserResponse> listUser = [];
  final DioNetworkManager _networkManager = DioNetworkManager();
  late IsolatedNetworkRequest isolatedNetworkRequest;
  late CancellationToken cancellationToken;

  UserDialogBloc() : super(UserDialogState.initial()) {
////////////////////////////////////////////////////////////////////////////////

    on<ConnectUserDialogEvent>((event, emit) async {
      emit(state.copyWithState(
        screenState: UserDialogScreenState.inprogress,
      ));

      if (await _user(event.host)) {
        emit(state.copyWithStateAndList(
          screenState: UserDialogScreenState.success,
          list: listUser,
        ));
      } else {
        print("on<ConnectUsersEvent> ERROR (${state.screenState})");

        if (state.screenState != UserDialogScreenState.aborted) {
          emit(state.copyWithState(screenState: UserDialogScreenState.failed));
        }
      }
    });

    on<AbortUserDialogEvent>((event, emit) {
      cancellationToken.cancel();

      emit(state.copyWithState(screenState: UserDialogScreenState.aborted));
    });
  }

  @override
  Future<void> close() {
    return super.close();
  }

  void onHandleError() {
    print("onHandleError");
  }

  Future<bool> _user(String url) async {
    final Map<String, dynamic> _headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8'
    };

    Dio dio = Dio() // Provide a dio instance
      ..options.connectTimeout = Duration(seconds: 15)
      ..options.receiveTimeout = Duration(seconds: 15)
      ..options.baseUrl = url
      ..options.headers = _headers
      ..interceptors.add(LogInterceptor(responseBody: true));

    isolatedNetworkRequest = IsolatedNetworkRequest(dio);
    cancellationToken = CancellationToken();

    final response = await _networkManager.performRequest(
        isolatedNetworkRequest, cancellationToken);
    if (response == null) {
      return false;
    }

    listUser = response;

    return true;
  }
}
