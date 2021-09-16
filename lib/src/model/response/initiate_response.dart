import 'dart:convert';

import 'package:online_payment/online_payment.dart';
import 'package:online_payment/src/model/enums/status_code.dart';

class InitiateResponse {
  InitiateResponse({
    this.code,
    this.message,
    this.data,
  });

  final StatusCode? code;
  final String? message;
  final Data? data;

  InitiateResponse jsonToModel(String str) {
    return InitiateResponse.fromRawJson(str);
  }

  factory InitiateResponse.fromRawJson(String str) =>
      InitiateResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory InitiateResponse.fromJson(Map<String, dynamic> json) =>
      InitiateResponse(
        code: json["code"] == null ? null : Utils.codeToEnum(int.parse(json["code"].toString())),
        message: json["message"] == null ? null : json["message"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "code": code == null ? null : code,
        "message": message == null ? null : message,
        "data": data == null ? null : data!.toJson(),
      };
}

class Data {
  Data({
    this.linkId,
    this.reason,
    this.type,
    this.status,
    this.amount,
    this.link,
    this.interest,
    this.bankTransactionCharge,
    this.payer,
  });

  final int? linkId;
  final String? reason;
  final String? type;
  final String? status;
  final double? amount;
  final String? link;
  final String? interest;
  final String? bankTransactionCharge;
  final Payer? payer;

  factory Data.fromRawJson(String str) => Data.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        linkId: json["link_id"] == null ? null : json["link_id"],
        reason: json["reason"],
        type: json["type"] == null ? null : json["type"],
        status: json["status"] == null ? null : json["status"],
        amount: json["amount"] == null ? null : double.parse(json["amount"].toString()),
        link: json["link"] == null ? null : json["link"],
        interest: json["interest"],
        bankTransactionCharge: json["bank_transaction_charge"],
        payer: json["payer"] == null ? null : Payer.fromJson(json["payer"]),
      );

  Map<String, dynamic> toJson() => {
        "link_id": linkId == null ? null : linkId,
        "reason": reason,
        "type": type == null ? null : type,
        "status": status == null ? null : status,
        "amount": amount == null ? null : amount,
        "link": link == null ? null : link,
        "interest": interest,
        "bank_transaction_charge": bankTransactionCharge,
        "payer": payer == null ? null : payer!.toJson(),
      };
}

class Payer {
  Payer({
    this.id,
    this.name,
    this.mobile,
  });

  final int? id;
  final String? name;
  final String? mobile;

  factory Payer.fromRawJson(String str) => Payer.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory Payer.fromJson(Map<String, dynamic> json) => Payer(
        id: json["id"] == null ? null : json["id"],
        name: json["name"] == null ? null : json["name"],
        mobile: json["mobile"] == null ? null : json["mobile"],
      );

  Map<String, dynamic> toJson() => {
        "id": id == null ? null : id,
        "name": name == null ? null : name,
        "mobile": mobile == null ? null : mobile,
      };
}
