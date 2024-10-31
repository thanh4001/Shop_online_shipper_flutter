import 'package:flutter_shipper_github/data/models/OrderModel.dart';

class ShipperReport {
  DateTime? datetime;
  List<OrderData>? listOrder;
  ShipperReport({
    this.datetime,
    this.listOrder,
  });
}
