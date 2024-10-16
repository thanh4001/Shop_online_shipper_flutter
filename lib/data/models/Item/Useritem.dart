
class Useritem {
  int? id;
  String? email;
  String? fullName;
  String? phoneNumber;
  String? address;
  double? longitude;
  double? latitude;
  String? avatar;
  String? createdAt;
  String? updatedAt;
  bool? accountLocked;
  bool? isActive;
  String? token;
  String? type;
  List<String>? roles;

  Useritem(
      {this.id,
      this.email,
      this.fullName,
      this.phoneNumber,
      this.address,
      this.longitude,
      this.latitude,
      this.avatar,
      this.createdAt,
      this.updatedAt,
      this.accountLocked,
      this.isActive,
      this.token,
      this.type,
      this.roles});

  Useritem.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    fullName = json['fullName'];
    phoneNumber = json['phoneNumber'];
    address = json['address'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    avatar = json['avatar'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    accountLocked = json['accountLocked'];
    isActive = json['isActive'];
    token = json['token'];
    type = json['type'];
    roles = json['roles'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['fullName'] = this.fullName;
    data['phoneNumber'] = this.phoneNumber;
    data['address'] = this.address;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['avatar'] = this.avatar;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['accountLocked'] = this.accountLocked;
    data['isActive'] = this.isActive;
    data['token'] = this.token;
    data['type'] = this.type;
    data['roles'] = this.roles;
    return data;
  }
}