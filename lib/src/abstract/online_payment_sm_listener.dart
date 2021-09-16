abstract class OnlinePaymentSMListener {
  final void Function() paymentSuccess;
  final void Function() paymentFailed;
  final void Function() paymentInComplete;

  OnlinePaymentSMListener(
    this.paymentSuccess,
    this.paymentFailed,
    this.paymentInComplete,
  );
}
