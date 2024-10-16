class Userlogindto {
  String? numberPhone;
  String? password;

  Userlogindto({
    this.numberPhone,
    this.password
  });
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = new Map<String, dynamic>();
    data["numberPhone"] = this.numberPhone;
    data["password"] = this.password;
    return data;
  }
}