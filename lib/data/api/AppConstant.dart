class Appconstant {
  static const  String APP_NAME = "NhatDepTrai";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "http://192.168.1.39:8080";

  static const String LOGIN_URL = "/api/v1/auth/login";
  static const String STORE_URL = "/api/v1/public/stores/all";
  static const String ORDER_URL = "/api/v1/shipper/order/all-one-shipper";
  static const String UPDATE_ORDER_URL = "/api/v1/shipper/order/update-status/{shipperOrderId}?OderDetailId={orderdetailId}";
  
  static const String TOKEN = "DBtoken";
}
