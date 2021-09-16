import 'package:dio/dio.dart';
import 'package:online_payment/online_payment.dart';
import 'package:online_payment/src/config/constants/app_service.dart';
import 'package:online_payment/src/utils/log_print.dart';

import 'handle_error.dart';

class HttpService {
  late Dio _dio;

  void init() {
    _dio = Dio(
      BaseOptions(
        baseUrl: AppService.BASE_URL,
        connectTimeout: AppService.TIMEOUT * 1000,
        headers: {
          "content-Type": "application/json; charset=UTF-8",
          "Accept": "application/json",
        },
        followRedirects: false,
        validateStatus: (status) {
          return status! < 500;
        },
      ),
    );

    initializeInterceptors();
    LogPrint.info("HttpService", "init", "dio init success");
  }

  Future<Response?> getRequest(String url) async {
    Response? response;
    try {
      response = await _dio.get(url);
    } on DioError catch (e, s) {
      LogPrint.error("HttpService", "getRequest", "Dio error found >> $e $s");
    }

    return response;
  }

  Future<Response?> postRequest(
    String url, [
    Map<String, dynamic>? data,
  ]) async {
    Response? response;
    try {
      response = await _dio.post(url, data: data);
    } on DioError catch (e) {
      LogPrint.error("HttpService", "postRequest", "Dio error on request");
      throw e;
    }
    return response;
  }

  Future<Response?> postRequestWithFile(
    String url, [
    Map<String, dynamic>? data,
    List<String?>? path,
  ]) async {
    Response? response;
    try {
      FormData formData = FormData.fromMap(data!);
      if (path != null && path.isNotEmpty)
        formData.files.addAll([
          for (String? p in path)
            //TODO add for multiple image
            MapEntry("prescriptions[]", await MultipartFile.fromFile(p!)),
        ]);

      response = await _dio.post(url, data: formData);
    } on DioError catch (e) {
      LogPrint.error(
          "HttpService", "postRequestWithFile", "Dio error on request");
    }
    return response;
  }

  void setHeaders(Map<String, dynamic>? headers) {
    _dio.options.headers = headers;
  }

  initializeInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Do something before request is sent
          // return handler.next(options); //continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
          LogPrint.info(
            "HttpService",
            "initializeInterceptors() -> onRequest",
            "PATH: ${options.path} | METHOD: ${options.method}",
          );

          LogPrint.info(
            "HttpService",
            "initializeInterceptors() -> onRequest",
            "\n\nHeaders: \n ${Utils.mapToString(options.headers)}\n",
          );

          return handler.next(options);
        },
        onResponse: (response, handler) {
          // Do something with response data
          // return handler.next(response); // continue
          // If you want to reject the request with a error message,
          // you can reject a `DioError` object eg: `handler.reject(dioError)`
          LogPrint.info(
            "HttpService",
            "initializeInterceptors() -> onResponse",
            "\n\nPATH: ${response.requestOptions.path}"
                "\nSTATUS CODE: ${response.statusCode}"
                "\nSTATUS MESSAGE: ${response.statusMessage}"
                "\nDATA:\n${LogPrint.isPrintResponseData ? Utils.mapToString(response.data) : "Response data show disabled"}",
          );
          return handler.next(response);
        },
        onError: (DioError e, handler) {
          // Do something with response error
          // return  handler.next(e);//continue
          // If you want to resolve the request with some custom data，
          // you can resolve a `Response` object eg: `handler.resolve(response)`.
          LogPrint.error(
            "HttpService",
            "initializeInterceptors() -> onError",
            e.message +
                " | PATH: ${e.response?.realUri.host}${e.response?.realUri.path}",
          );
          HandleError.handle(e);
          return handler.next(e);
        },
      ),
    );
  }
}
