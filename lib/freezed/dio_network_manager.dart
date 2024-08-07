import 'dart:developer';
import 'package:cancellation_token/cancellation_token.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_reminder/freezed/requests/isolated_network_request.dart';
import 'package:flutter_reminder/freezed/responses/user_response.dart';

class DioNetworkManager {
  Future performRequest(
    IsolatedNetworkRequest isolatedRequest,
    CancellationToken cancellationToken,
  ) async {
    try {
      final response = await CancellableIsolate.run(
        () {
          return compute(executeRequest, isolatedRequest);
        },
        cancellationToken,
      );

      return response;
    } on CancelledException {
      return [];
    } catch (e) {
      log(e.toString());
      return null;
    }
  }
}

Future executeRequest(
  IsolatedNetworkRequest isolatedRequest,
) async {
  try {
    final response = await isolatedRequest.dio.request(
      '/api/?results=15',
      options: Options(
        method: "GET",
      ),
    );
    return UserRandomResponse.fromJson(response.data).list;
  } catch (error) {
    return Future.error(error);
  }
}
