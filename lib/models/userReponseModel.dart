// To parse this JSON data, do
//
//     final userResponseModel = userResponseModelFromJson(jsonString);

import 'dart:convert';

List<userResonseModel> userResponseModelFromJson(String str) => List<userResonseModel>.from(json.decode(str).map((x) => userResonseModel.fromJson(x)));

String userResponseModelToJson(List<userResonseModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class  userResonseModel {
  dynamic id;
  String name;
  String email;
  String mobile;
  String gender;

  userResonseModel({
    required this.id,
    required this.name,
    required this.email,
    required this.mobile,
    required this.gender,
  });


  factory userResonseModel.fromSqfliteDatabase(Map<String, dynamic> map) => userResonseModel(
    id: map['id'] ?? null,
    name: map['name'] ?? '',
    email: map['email'] ?? '',
    mobile: map['mobile'] ?? '',
    gender: map['gender'] ?? '',
  );



  factory userResonseModel.fromJson(Map<String, dynamic> json) => userResonseModel(
    id: json["_id"],
    name: json["name"],
    email: json["email"],
    mobile: json["mobile"],
    gender: json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "name": name,
    "email": email,
    "mobile": mobile,
    "gender": gender,
  };
}
