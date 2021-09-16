# sManager Online Payment - FLUTTER

A package for online payment. Its depends on sManager policy.

Our goal is to reach the doorsteps of every merchant with the help of information and applications provided by **sMANAGER**, an application with various information related to the business's daily sales, bookkeeping, buying goods, keeping personal accounts very easily and accurately.
We are providing sManager Online Payment for **FLUTTER**. For, now it only supports **Android** and **iOS** only.

##### Depends On

* [dio - ^4.0.0](https://pub.dev/packages/dio)
* [flutter_inappwebview - ^5.3.2](https://pub.dev/packages/flutter_inappwebview)
* [sManager Subscription](https://play.google.com/store/apps/details?id=xyz.sheba.managerapp)
* [uuid: - ^3.0.4](https://pub.dev/packages/uuid)

##### Workflow
Step 1. Initiate Payment Link
Step 2. <code>Step 1</code> return a **JSON** response with a **link**
Step 3. Go to **link** form <code>Step 2</code> and start payment process
Step 4. <code>Step 3</code> return success or failure response


##### How to use
Way 1. Follow the Workflow
Way 2. Use Widget
Get Payment Details

##### Source
Read full details [here](https://smanagerit.xyz/online-payment-doc)
Example code [here]()
Demo APK [here]()

## Getting Started


###### Deployment Target

> For IOS : Not Test Yet

> For Android : **minSdkVersion 17**

###### Installation
> With Flutter:
```bash
flutter pub add online_payment
```

This will add a line like this to your package's pubspec.yaml (and run an implicit dart pub get):
```yaml
dependencies:
  flutter:
    sdk: flutter

  # add package for online payment
  online_payment: ^0.0.1
```

> Import it
```dart
import 'package:online_payment/online_payment.dart';
```

#### Way 1 (Workflow)
###### Step 1 (Initiate Payment Link)
Replace **CLIENT_ID** and **CLIENT_SECRET**
*Collect **CLIENT_ID** and **CLIENT_SECRET** form sManager*
```dart
final Credentials _credentials = Credentials(
    "CLIENT_ID",
    "CLIENT_SECRET",
  );
  ```
 
 Replace **SUCCESS_URL** and **FAILED_URL**
 ```dart
 /// make sure successUrl and failedUrl is not same
  InitiateData _initiateData = InitiateData(
    amount: 500,
    successUrl: "SUCCESS_URL",
    failedUrl: "FAILED_URL",
  );
  ```
 
 
  ```dart
  OnlinePayment _onlinePayment = OnlinePayment(
    credentials: _credentials, 
    initiateData: _initiateData,
  );
  ```
  ###### Step 2 (Get payment link)
  
  ```dart
  await _onlinePayment!.initiate.then((InitiateResponse initiateResponse) {
      print("Payment Initiate Response Data: ${initiateResponse.toJson()}");
    });
  ```
  Response look like this
  ```json
  {
    "code": 200,
    "message": "Successful",
    "data": {
        "link_id": 3587,
        "reason": "Online Payment",
        "type": "fixed",
        "status": "active",
        "amount": 500,
        "link": "https://xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx",
        "emi_month": 0,
        "interest": null,
        "bank_transaction_charge": null,
        "paid_by": "partner",
        "partner_profit": 0,
        "payer": {
            "id": 1078,
            "name": "Name",
            "mobile": "+880xxxxxxxxxx"
        }
    }
}
  ```

 ###### Step 3 (Call link)
 Open link using this [flutter_inappwebview - ^5.3.2](https://pub.dev/packages/flutter_inappwebview)
 
 ###### Step 4 (Webview Response)
Take decision based on webview response

#### Way 2 (Widget)
```dart
OnlinePaymentSM(
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
)
```

#### Get Payment Details
```dart
_onlinePayment.paymentDetails(TRANSACTION_ID).then((PaymentDetails paymentDetails){
        /// TODO do your work
    });
```

#### Response Code
```dart
/// 200	success
/// 400	The transaction id field is required
/// 404	The given transaction ID not found
/// 501	This client is not published
/// 502	The ip <$ip> you are accessing from is not whitelisted
/// 503	Client id or secret is missing from the request
/// 504	Client ID and Secret does not match
/// 505	Invalid Transaction ID, Please provide a unique transaction ID
/// 507	Failed to initiate Payment Link


  StatusCode.SUCCESS
  StatusCode.TRANSACTION_ID_FIELD_REQUIRED
  StatusCode.TRANSACTION_ID_NOT_FOUND
  StatusCode.CLIENT_NOT_PUBLISHED
  StatusCode.IP_NOT_WHITELIST
  StatusCode.CLIENT_ID_OR_SECRET_MISSING
  StatusCode.CLIENT_ID_OR_SECRET_NOT_MATCH
  StatusCode.INVALID_TRANSACTION_ID
  StatusCode.FAILED_TO_INITIATE

```

### Contributors

>Md. Khalid Hassan

- Author : sManager Technology
- Email: smanager.tech@gmail.com (For any query)
- About sManager Technology: https://smanagerit.xyz/
- About sManager: https://smanager.xyz/

© 2021 sManager Technology ALL RIGHTS RESERVED
