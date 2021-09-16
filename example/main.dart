import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:online_payment/online_payment.dart';

void main() {
  runApp(
    MaterialApp(
      home: PaymentWithWidget(),
    ),
  );
}

class GetPaymentInitiateUrl extends StatefulWidget {
  const GetPaymentInitiateUrl({Key? key}) : super(key: key);

  @override
  _GetPaymentInitiateUrlState createState() => _GetPaymentInitiateUrlState();
}

class _GetPaymentInitiateUrlState extends State<GetPaymentInitiateUrl> {
  OnlinePayment? _onlinePayment;

  final Credentials _credentials = Credentials(
    clientId: "CLIENT_ID",
    clientSecret: "CLIENT_SECRET",
  );

  InitiateData _initiateData = InitiateData(
    amount: 500,
    transactionId: Utils.getUniqueTransactionId,
    successUrl: "SUCCESS_URL", // http://google.com
    failedUrl: "FAILED_URL", // http://youtube.com
  );

  // Future<void> startPaymentInitiate() async {
  //   await _onlinePayment.initiate.then((InitiateResponse initiateResponse) {
  //     print("Payment Initiate Response Data: ");
  //     print(initiateResponse.toJson());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    _onlinePayment = OnlinePayment(
      credentials: _credentials,
      initiateData: _initiateData..transactionId = Utils.getUniqueTransactionId,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("Online Payment Initiate"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Center(
          child: FutureBuilder<InitiateResponse>(
            future: _onlinePayment?.initiate,
            builder: (
              BuildContext context,
              AsyncSnapshot<InitiateResponse> snapshot,
            ) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasError) {
                  return Text(
                    "Data Fetched Error",
                    style: TextStyle(
                      color: Colors.red,
                    ),
                  );
                }
                return body(snapshot.data);
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),

      // body: Center(
      //   child: ElevatedButton(
      //     onPressed: startPaymentInitiate,
      //     child: Text("Start Initiate"),
      //   ),
      // ),
    );
  }

  Widget body(InitiateResponse? response) {
    return (response?.code ?? 507) == 200
        ? startPayment(response)
        : showFailedMsg(response?.message ?? "Failed to initiate");
  }

  Widget startPayment(InitiateResponse? response) {
    return Column(
      children: [
        Text(
          "Implement a webview and start with initUrl",
          style: TextStyle(color: Colors.green),
        ),
        if (response!.data != null)
          Text(Utils.mapToString(response.data!.toJson())),
      ],
    );
  }

  Widget showFailedMsg(String msg) {
    return Text(
      msg,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: Colors.red,
        fontSize: 20.0,
      ),
    );
  }
}


/// OR

class PaymentWithWidget extends StatefulWidget {
  const PaymentWithWidget({Key? key}) : super(key: key);

  @override
  _PaymentWithWidgetState createState() => _PaymentWithWidgetState();
}

class _PaymentWithWidgetState extends State<PaymentWithWidget> {
  late Credentials _credentials;
  late InitiateData _initiateData;
  late OnlinePayment onlinePayment;

  final String trxId = Utils.getUniqueTransactionId;

  @override
  void initState() {
    super.initState();
    _credentials = Credentials(
      clientId: "CLIENT_ID",
      clientSecret: "CLIENT_SECRET",
    );

    /// [transactionId] is important because of ger payment details
    /// [transactionId] must be unique
    _initiateData = InitiateData(
      amount: 500,
      transactionId: trxId,
      successUrl: "SUCCESS_URL", // http://google.com
      failedUrl: "FAILED_URL", // http://youtube.com
    );

    onlinePayment = OnlinePayment(
      credentials: _credentials,
      initiateData: _initiateData,
    );
  }

  void getPaymentDetails() {
    onlinePayment.paymentDetails(trxId).then((PaymentDetails paymentDetails) {
      /// TODO do your work
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: OnlinePaymentSM(
        credentials: _credentials,
        initiateData: _initiateData,
        paymentSuccess: () {
          print("paymentSuccess");

          /// TODO implement here
        },
        paymentFailed: () {
          /// TODO implement here
          print("paymentFailed");
        },
        paymentInComplete: () {
          /// TODO implement here
          print("paymentInComplete");
        },
      ),
    );
  }
}
