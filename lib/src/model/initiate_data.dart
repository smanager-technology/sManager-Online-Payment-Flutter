import 'package:online_payment/src/config/constants/app_strings.dart';

class InitiateData {
  /// total payable
  double amount;

  /// [transactionId] is always unique. [transactionId] will automatically
  /// generate if [transactionId] is null
  String transactionId;

  /// [successUrl] contains an url. this url call when payment successfully
  String successUrl;

  /// [failedUrl] contains an url. this url call when payment failed
  String failedUrl;

  /// user name
  String? customerName;

  /// customer mobile number
  String? customerMobile;

  /// purpose of payment
  String? purpose;

  /// payment details
  String? paymentDetails;

  InitiateData({
    required this.amount,
    required this.transactionId,
    required this.successUrl,
    required this.failedUrl,
    this.customerName,
    this.customerMobile,
    this.purpose,
    this.paymentDetails,
  })  : assert(amount >= 10,
            "Invalid 'amount'. At least 10 TK need for Online Payment"),
        assert(successUrl.isNotEmpty,
            "Invalid 'successUrl'. Success Url can't empty"),
        assert(
            failedUrl.isNotEmpty, "Invalid 'failedUrl'. Filed Url can't empty"),
        assert(
          successUrl.toLowerCase().startsWith("http://") ||
              successUrl.toLowerCase().startsWith("https://"),
          "Invalid 'successUrl'. Format invalid. Please start with http:// or https://",
        ),
        assert(
          failedUrl.toLowerCase().startsWith("http://") ||
              failedUrl.toLowerCase().startsWith("https://"),
          "Invalid 'failedUrl'. Format invalid. Please start with http:// or https://",
        ),
        assert(
          successUrl.toLowerCase() != failedUrl.toLowerCase(),
          "Make sure 'successUrl' and 'failedUrl' are not same",
        );

  Map<String, dynamic> toJson() => {
        AppStrings.keys.amount: this.amount,
        AppStrings.keys.transactionId: this.transactionId,
        AppStrings.keys.successUrl: this.successUrl,
        AppStrings.keys.failedUrl: this.failedUrl,
        AppStrings.keys.customerName: this.customerName,
        AppStrings.keys.customerMobile: this.customerMobile,
        AppStrings.keys.purpose: this.purpose,
        AppStrings.keys.paymentDetails: this.paymentDetails,
      };

  void printInitialData() {
    print(toJson());
  }
}
