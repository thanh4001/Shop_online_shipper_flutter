class Registerdto {
  String? fullName;
  String? password;
  String? phoneNumber;
  String? email;
  String? address;
  String? code;

  Registerdto(
      {this.fullName,
      this.password,
      this.phoneNumber,
      this.email,
      this.address,
      this.code});
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['password'] = this.password;
    data['phoneNumber'] = this.phoneNumber;
    data['email'] = this.email;
    data['address'] = this.address;
    data['code'] = this.code;
    return data;
  }
}