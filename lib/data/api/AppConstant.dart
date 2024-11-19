class Appconstant {
  static const  String APP_NAME = "NhatDepTrai";
  static const int APP_VERSION = 1;

  static const String BASE_URL = "http://10.10.27.107:8080";

  static const String LOGIN_URL = "/api/v1/auth/login";
  static const String REGISTER_URL = "/api/v1/auth/register-shipper";
  static const String UPDATE_PROFILE_URL = "/api/v1/user/auth/profiles/updates";
  static const String GET_PROFILE_URL = "/api/v1/public/user/{id}";
  static const String STORE_URL = "/api/v1/public/stores/all";
  static const String UPDATE_LOCATION_URL = "/api/v1/shipper/location?newLatitude={latitude}&newLongitude={longtitude}";
  static const String ORDER_URL = "/api/v1/shipper/order/all-of-shipper";
  static const String UPDATE_ORDER_URL = "/api/v1/shipper/order/update-status/{shipperOrderId}?OderDetailId={orderdetailId}";
  static const String CUSTOMER_PROFILE_URL = "/api/v1/public/user/{id}";
  static const String ACCEPT_ORDER_URL = "/api/v1/shipper/order/approve/{shipperOrderId}?isAccepted=true";
  static const String FINISH_ORDER_URL = "/api/v1/shipper/order/finish-delivery/{shipperOrderId}?OderDetailId={orderdetailId}";
  static const String TOKEN = "DBtoken";
}
