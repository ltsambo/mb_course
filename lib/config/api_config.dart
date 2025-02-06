// String _baseUrl = "http://www.ltsambosg.com";
String _baseUrl = "http://10.10.11.11:8000/api";

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
