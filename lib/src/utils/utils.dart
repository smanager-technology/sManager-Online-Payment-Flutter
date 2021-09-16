import 'package:online_payment/src/model/enums/status_code.dart';
import 'package:uuid/uuid.dart';

class Utils {
  static String get getUniqueTransactionId => Uuid().v1();

  static String mapToString(Map<String, dynamic> headers) {
    List<String> _headersParts = headers.toString().split(",");
    String _formattedHeaders = "";
    for (String part in _headersParts) {
      _formattedHeaders += part;
      _formattedHeaders += "\n";
    }

    _formattedHeaders = _formattedHeaders.replaceAll("{", "");
    _formattedHeaders = _formattedHeaders.replaceAll("}", "");

    return _formattedHeaders;
  }

  static StatusCode codeToEnum(int code) {
    List<int> _code = [200, 400, 404, 501, 502, 503, 504, 505, 507];

    return StatusCode.values.elementAt(_code.indexOf(code));
  }
}
