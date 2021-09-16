import 'package:dio/dio.dart';
import 'package:online_payment/src/utils/log_print.dart';

class HandleError {
  static handle(error) {
    // dio default error
    if(error is DioError)
    switch (error.type) {
      case DioErrorType.connectTimeout:
      case DioErrorType.sendTimeout:
      case DioErrorType.receiveTimeout:
      LogPrint.info("HandleError", "handle", "Internet connection is too slow. Check your connection and try again");
        // Dialogs.show.apiError(
        //   "Internet connection is too slow. Check your connection and try again",
        //   title: "Request Timeout",
        // );
        break;
      case DioErrorType.response:
        LogPrint.info("HandleError", "handle", error.response!.requestOptions.path);

        // Dialogs.show.apiError(
        //   error.message,
        //   title: "Error ${error.response!.statusCode}",
        //   path: error.response!.requestOptions.path,
        // );
        break;
      case DioErrorType.cancel:
        break;
      case DioErrorType.other:
        // custom error based on msg result
        if (error.message.contains("SocketException")) {
          // Dialogs.show.noInternet;
          LogPrint.info("HandleError", "handle", "No Internet");
        } else {
          LogPrint.info("HandleError", "handle", error.message);
          // Dialogs.show.apiError(error.message);
        }
    }
  }
}
