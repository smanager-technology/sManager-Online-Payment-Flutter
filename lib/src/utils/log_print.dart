class LogPrint {
  static const bool _IS_DEBUG = true;

  /// if [_IS_DEBUG] is false then
  /// [isPrintResponseData] no work
  static const bool isPrintResponseData = true;

  static void error(String className, String methodMame, dynamic error) {
    _print("ERROR -> $className{} -> $methodMame() -> $error");
  }

  static void success(String className, String methodMame, dynamic success) {
    _print("SUCCESS -> $className{} -> $methodMame() -> $success");
  }

  static void info(String className, String methodMame, dynamic info) {
    _print("INFO -> $className{} -> $methodMame() -> $info");
  }

  static void _print(msg) {
    if (_IS_DEBUG) print("ONLINE PAYMENT INTEGRATION FLUTTER: " + msg);
  }
}
