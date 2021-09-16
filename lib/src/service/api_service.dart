import 'dart:async';

import 'package:online_payment/online_payment.dart';
import 'package:online_payment/src/config/constants/app_service.dart';
import 'package:online_payment/src/model/credentials.dart';
import 'package:online_payment/src/model/response/payment_details.dart';
import 'package:online_payment/src/utils/log_print.dart';

import 'http_service.dart';

class ApiService {
  // dio constant
  static HttpService _http = HttpService()..init();

  // api urls
  static var _urls = AppService.url;

  // print error and show dialog
  static void _showErrorDialog(String methodName, error, stackTrace) {
    LogPrint.error(
      "ApiService",
      methodName + "() -> _showErrorDialog",
      error.toString(),
    );
    LogPrint.error(
      "ApiService",
      methodName + "() -> _showErrorDialog",
      stackTrace.toString(),
    );
    // Dialogs.show.stackTrace(error.toString(), stackTrace.toString());
  }

  static dynamic _handleResponse(response, classInstance) {
    if (response != null) {
      try {
        return classInstance.jsonToModel(response.toString());
      } catch (error, stacktrace) {
        _showErrorDialog("_handleResponse", error, stacktrace);
      }
    }

    return null;
  }

  /// POST
  static Future<InitiateResponse> initiate(
    Credentials credentials,
    InitiateData initiateData,
  ) async {
    LogPrint.error(
      "ApiService",
      "initiate",
      "TRANSACTION ID: ${initiateData.transactionId}",
    );

    _http.setHeaders(credentials.toJson());

    var response = await _http.postRequest(
      _urls.initiate,
      initiateData.toJson(),
    );

    return _handleResponse(response, InitiateResponse());
  }

  /// get details
  static Future<PaymentDetails> getDetails(
    Credentials credentials,
    String trxId,
  ) async {
    LogPrint.error(
      "ApiService",
      "getDetails",
      "TRANSACTION ID: $trxId",
    );

    _http.setHeaders(credentials.toJson());

    var response = await _http.postRequest(
      _urls.initiate,
      {
        "transaction_id": trxId,
      },
    );

    return _handleResponse(response, PaymentDetails());
  }
}
