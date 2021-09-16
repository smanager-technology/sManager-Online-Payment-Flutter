import 'dart:convert';

import 'package:online_payment/src/model/enums/status_code.dart';

import '../../../online_payment.dart';

class PaymentDetails {
  PaymentDetails({
    this.code,
    this.message,
  });

  final StatusCode? code;
  final String? message;

  PaymentDetails jsonToModel(String str) {
    return PaymentDetails.fromRawJson(str);
  }

  factory PaymentDetails.fromRawJson(String str) => PaymentDetails.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory PaymentDetails.fromJson(Map<String, dynamic> json) => PaymentDetails(
    code: json["code"] == null ? null : Utils.codeToEnum(int.parse(json["code"].toString())),
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "code": code == null ? null : code,
    "message": message == null ? null : message,
  };
}
