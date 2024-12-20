class Ordermodels {
  bool? success;
  String? message;
  List<OrderData>? orderlist;
  List<OrderData>? get getorderlist => orderlist;

  Ordermodels({this.success, this.message, this.orderlist});

  Ordermodels.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      orderlist = <OrderData>[];
      json['data'].forEach((v) {
        orderlist!.add(new OrderData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['success'] = this.success;
    data['message'] = this.message;
    if (this.orderlist != null) {
      data['data'] = this.orderlist!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
class OrderData {
  int? shipperOrderId;
  int? shipperId;
  String? status;
  String? receivedAt;
  String? deliveredAt;
  int? storeId;
  String? createdAt;
  String? updatedAt;
  int? orderId;
  String? orderCode;
  int? userId;
  String? orderDate;
  double? totalAmount;
  double? shippingFee;
  String? deliveryAddress;
  double? longitude;
  double? latitude;
  List<OrderDetails>? orderDetails;

  OrderData(
      {
        this.shipperOrderId,
      this.shipperId,
      this.status,
      this.receivedAt,
      this.deliveredAt,
      this.storeId,
      this.createdAt,
      this.updatedAt,
      this.orderId,
      this.orderCode,
      this.userId,
      this.orderDate,
      this.totalAmount,
      this.shippingFee,
      this.deliveryAddress,
      this.longitude,
      this.latitude,
      this.orderDetails});

  OrderData.fromJson(Map<String, dynamic> json) {
    shipperOrderId = json['shipperOrderId'];
    shipperId = json['shipperId'];
    status = json['status'];
    receivedAt = json['receivedAt'];
    deliveredAt = json['deliveredAt'];
    storeId = json['storeId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    orderId = json['orderId'];
    orderCode = json['orderCode'];
    userId = json['userId'];
    orderDate = json['orderDate'];
    totalAmount = json['totalAmount'];
    shippingFee = json['shippingFee'];
    deliveryAddress = json['deliveryAddress'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    if (json['orderDetails'] != null) {
      orderDetails = <OrderDetails>[];
      json['orderDetails'].forEach((v) {
        orderDetails!.add(new OrderDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['shipperOrderId'] = this.shipperOrderId;
    data['shipperId'] = this.shipperId;
    data['status'] = this.status;
    data['receivedAt'] = this.receivedAt;
    data['deliveredAt'] = this.deliveredAt;
    data['storeId'] = this.storeId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['orderId'] = this.orderId;
    data['orderCode'] = this.orderCode;
    data['userId'] = this.userId;
    data['orderDate'] = this.orderDate;
    data['totalAmount'] = this.totalAmount;
    data['shippingFee'] = this.shippingFee;
    data['deliveryAddress'] = this.deliveryAddress;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    if (this.orderDetails != null) {
      data['orderDetails'] = this.orderDetails!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderDetails {
  String? type;
  ProductDetail? productDetail;
  ComboDetail? comboDetail;

  OrderDetails({this.type, this.productDetail, this.comboDetail});

  OrderDetails.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    productDetail = json['productDetail'] != null
        ? new ProductDetail.fromJson(json['productDetail'])
        : null;
    comboDetail = json['comboDetail'] != null
        ? new ComboDetail.fromJson(json['comboDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    if (this.productDetail != null) {
      data['productDetail'] = this.productDetail!.toJson();
    }
     if (this.comboDetail != null) {
      data['comboDetail'] = this.comboDetail!.toJson();
    }
    return data;
  }
}

class ProductDetail {
  int? orderDetailId;
  int? productId;
  String? productName;
  String? description;
  String? productImage;
  String? category;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  String? size;
  List<int>? drinkId;
  int? storeId;
  String? status;
  bool? bestSeller;

  ProductDetail(
      {this.orderDetailId,
      this.productId,
      this.productName,
      this.description,
      this.productImage,
      this.category,
      this.quantity,
      this.unitPrice,
      this.totalPrice,
      this.size,
      this.drinkId,
      this.storeId,
      this.status,
      this.bestSeller});

  ProductDetail.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['orderDetailId'];
    productId = json['productId'];
    productName = json['productName'];
    description = json['description'];
    productImage = json['productImage'];
    category = json['category'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    size = json['size'];
    drinkId = (json['drinkId'] as List<dynamic>?)?.map((item) => item as int).toList();
    storeId = json['storeId'];
    status = json['status'];
    bestSeller = json['bestSeller'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['orderDetailId'] = this.orderDetailId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['description'] = this.description;
    data['productImage'] = this.productImage;
    data['category'] = this.category;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['totalPrice'] = this.totalPrice;
    data['size'] = this.size;
    data['drinkId'] = this.drinkId;
    data['storeId'] = this.storeId;
    data['status'] = this.status;
    data['bestSeller'] = this.bestSeller;
    return data;
  }
}
class ComboDetail {
  int? orderDetailId;
  int? comboId;
  int? quantity;
  double? unitPrice;
  double? totalPrice;
  String? size;
  List<int>? drinkId;
  int? storeId;
  String? status;

  ComboDetail({
    this.orderDetailId,
    this.comboId,
    this.quantity,
    this.unitPrice,
    this.totalPrice,
    this.size,
    this.drinkId,
    this.storeId,
    this.status,
  });

  ComboDetail.fromJson(Map<String, dynamic> json) {
    orderDetailId = json['orderDetailId'];
    comboId = json['comboId'];
    quantity = json['quantity'];
    unitPrice = json['unitPrice'];
    totalPrice = json['totalPrice'];
    size = json['size'];
    // Ensure drinkId is properly converted from dynamic to List<int>
    drinkId = (json['drinkId'] as List<dynamic>?)?.map((item) => item as int).toList();
    storeId = json['storeId'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['orderDetailId'] = this.orderDetailId;
    data['comboId'] = this.comboId;
    data['quantity'] = this.quantity;
    data['unitPrice'] = this.unitPrice;
    data['totalPrice'] = this.totalPrice;
    data['size'] = this.size;
    // Convert drinkId list to JSON
    data['drinkId'] = this.drinkId;
    data['storeId'] = this.storeId;
    data['status'] = this.status;
    return data;
  }
}

