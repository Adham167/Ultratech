class ApiConstants {
  static const String baseUrl =
      "https://ultratech1.runasp.net/api/";

  // Auth
  static const String login = "Auth/login";
  static const String registerEmployee =
      "Auth/register-employee";
  static const String refreshToken =
      "Auth/refresh-token";

  static const String forgotPassword =
      "Auth/forgot-password";

  static const String resetPassword =
      "Auth/reset-password";

  static const String changePassword =
      "Auth/change-password";

  // العملاء والصيانة والأوردرات
  static const String checkPhone =
      "Customers/check-phone/";

  static const String customers = "Customers";

  static const String areas = "Areas";

  static const String authMe = "Auth/me";

  static const String myAssignedMaintenance =
      "Maintenance/my-assigned";

  static const String myOrders =
      "Orders/my-orders";

  static const String myEarnings =
      'Employees/my-earnings';

  static const String orderDetails =
      "Orders/";

  static const String products =
      "Products";

  static String invoiceDetails(int id) =>
      'Invoices/$id';

  static const String myInvoices =
      "Invoices/my-invoices";

  static String acceptOrder(int id) =>
      "Orders/$id/accept";

  static String startOrder(int id) =>
      "Orders/$id/start";

  static String completeOrder(int id) =>
      "Orders/$id/complete";
}