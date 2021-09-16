class AppStrings {
  static _Keys get keys => _Keys();
}

class _Keys {
  // header
  String clientId = "client-id";
  String clientSecret = "client-secret";

  // payment initiate
  String amount = "amount";
  String transactionId = "transaction_id";
  String successUrl = "success_url";
  String failedUrl = "fail_url";
  String customerName = "customer_name";
  String customerMobile = "customer_mobile";
  String purpose = "purpose";
  String paymentDetails = "payment_details";
}
