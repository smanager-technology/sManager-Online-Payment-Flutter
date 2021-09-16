class AppService {
  static const String BASE_URL = "https://api.dev-sheba.xyz/v1/";

  // connection timeout
  static const int TIMEOUT = 120; // seconds

  // urls
  static _Url url = _Url();
}

class _Url {
  String get initiate => "ecom-payment/initiate";
}
