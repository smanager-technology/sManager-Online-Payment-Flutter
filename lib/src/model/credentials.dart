import 'package:online_payment/src/config/constants/app_strings.dart';

class Credentials {
  /// collect [clientId] from sManager
  String clientId;

  /// collect [clientSecret] from sManager
  String clientSecret;

  Credentials({
    required this.clientId,
    required this.clientSecret,
  })  : assert(clientId.isNotEmpty, "Client Id can't empty"),
        assert(clientSecret.isNotEmpty, "Client secret can't empty");

  Map<String, dynamic> toJson() => {
        AppStrings.keys.clientId: this.clientId,
        AppStrings.keys.clientSecret: this.clientSecret,
      };

  void printCredentials() {
    print(toJson());
  }
}
