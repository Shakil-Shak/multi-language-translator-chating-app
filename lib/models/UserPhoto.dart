class UserPhoto {
  String? profilepic;
  String? coverPhoto;

  UserPhoto({
    this.profilepic,
    this.coverPhoto,
  });

  UserPhoto.fromMap(Map<String, dynamic> map) {
    profilepic = map["profilepic"];
    coverPhoto = map["coverphoto"];
  }
  Map<String, dynamic> toMap() {
    return {
      "profilepic": profilepic,
      "coverphoto": coverPhoto,
    };
  }
}
