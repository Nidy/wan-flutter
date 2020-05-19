class UserModel {
  int id;
  String mobile;
  String headImage;

  UserModel({this.id, this.mobile, this.headImage});

  UserModel.fromJson(Map<String, dynamic> map) {
    this.id = map['id'];
    this.mobile = map['mobile'];
    this.headImage = map['headImage'];
  }
}