class Shipperrequest {
  String? fullName;
  String? avatar;
  String? email;
  String? address;
  double? latitude;
  double? longitude;

  Shipperrequest({
  required this.fullName,
  required this.avatar,
  required this.email,
  required this.address,
  required this.latitude,
  required this.longitude,
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["fullName"] = this.fullName;
    data["avatar"] = this.avatar;
    data["email"] = this.email;
    data["address"] = this.address;
    data["latitude"] = this.latitude;
    data["longitude"] = this.longitude;
    return data;
  }
}