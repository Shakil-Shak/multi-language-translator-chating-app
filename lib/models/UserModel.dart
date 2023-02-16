import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  String? uid;
  String? firstname;
  String? lastname;
  String? email;
  String? number;
  String? countryName;
  String? countryFlag;
  String? countryCode;
  String? profilepic;
  String? coverPhoto;
  String? facebook;
  String? github;
  String? city;
  String? address;
  String? fcmToken;


  UserModel(
      {this.uid,
      this.firstname,
      this.lastname,
      this.email,
      this.number,
      this.profilepic,
      this.countryName,
      this.countryFlag,
      this.countryCode,
      this.address,
      this.city,
      this.coverPhoto,
      this.facebook,
      this.github,
      this.fcmToken
      });

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map["uid"];
    firstname = map["fullname"];
    lastname = map["lastname"];
    email = map["email"];
    number = map["number"];
    profilepic = map["profilepic"];
    countryName = map["countryname"];
    countryFlag = map["countryflag"];
    countryCode = map["countrycode"];
    address = map["address"];
    city = map["city"];
    coverPhoto = map["coverphoto"];
    facebook = map["facebook"];
    github = map["github"];
    fcmToken = map["fcmtoken"];
  }
  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "fullname": firstname,
      "lastname": lastname,
      "email": email,
      "number": number,
      "profilepic": profilepic,
      "countryname": countryName,
      "countryflag": countryFlag,
      "countrycode": countryCode,
      "address": address,
      "city": city,
      "coverphoto": coverPhoto,
      "facebook": facebook,
      "github": github,
       "fcmtoken": fcmToken,
    };
  }
}
