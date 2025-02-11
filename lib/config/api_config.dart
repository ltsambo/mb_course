// String _baseUrl = "http://www.ltsambosg.com";
String _baseUrl = "http://192.168.68.63:8000/api";

// Auth 
String refreshTokenUrl = "$_baseUrl/user/token/refresh/";
String registerUrl = "$_baseUrl/user/register/";
String adminUserCreateUrl = "$_baseUrl/user/admin/create-user/";
String userListUrl = "$_baseUrl/user/list/";

String userProfileUrl(int userId) {
  return "$_baseUrl/user/$userId";
}

String changePasswordUrl = "$_baseUrl/user/password/change/";
String loginUrl = "$_baseUrl/user/login/";
String logoutUrl = "$_baseUrl/employee/api/logout/";

// Profile
String profileUrl = "$_baseUrl/employee/api/user-profile/";

// Course
String coursesUrl = "$_baseUrl/course/";
String courseCreateUrl = "$_baseUrl/course/create/";
String courseUpdateUrl(int courseId) {
  return "$_baseUrl/course/update/$courseId/";
}
String courseDeleteUrl(int courseId) {
  return "$_baseUrl/course/delete/$courseId/";
}

// Cart
String addToCartUrl = "$_baseUrl/cart/add/";
String fetchUserCartUrl = "$_baseUrl/cart/";
String cartCourseRemoveUrl(int cart_item_id) {
  return "$_baseUrl/cart/delete/$cart_item_id/";
}
String cartCourseRemoveAllUrl = "$_baseUrl/cart/delete_all/";

// Checkout - Orders
String checkoutUrl = "$_baseUrl/order/checkout/";
String fetchUserOrderUrl = "$_baseUrl/order/";
String orderPaymentUrl = "$_baseUrl/order/payment/order-payments/";
String retrievePaymentAcceptanceUrl = "$_baseUrl/order/acceptance/pending-acceptance-orders/";
// String approvePayment = "$_baseUrl/order"