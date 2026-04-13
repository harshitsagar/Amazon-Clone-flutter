class ApiConstants {

  static const String baseUrl = 'http://192.168.1.11:3002';
  // If using mobile emulator, you might need:
  // static const String baseUrl = 'http://10.0.2.2:3002'; // for Android emulator
  // static const String baseUrl = 'http://localhost:3002'; // for iOS simulator

  // API Endpoints .....

  // user ....
  static const String signUp = '${baseUrl}/api/signup';
  static const String signIn = '${baseUrl}/api/signin';
  static const String tokenIsValid = '${baseUrl}/api/tokenIsValid';
  static const String getUserData = '${baseUrl}/userdata';
  static String getAllCategory(String category) => '${baseUrl}/api/products?category=$category';
  static String getAllSearchedCategory(String searchQuery) => '${baseUrl}/api/products/search/$searchQuery';
  static const String rateProduct = '${baseUrl}/api/rate-product';
  static const String getDealOfDay = '${baseUrl}/api/deal-of-day';
  static const String addToCart = '${baseUrl}/api/add-to-cart';
  static String removeFromCart(String productId) => '${baseUrl}/api/remove-from-cart/$productId';
  static const String saveUserAddress = '${baseUrl}/api/save-user-address';
  static const String order = '${baseUrl}/api/order';
  static const String getMyOrders = '${baseUrl}/api/my-orders';
  static const String updateUserType = '${baseUrl}/api/update-user-type';


  // admin .....
  static const String addProduct = '${baseUrl}/admin/add-product';
  static const String getAllProducts = '${baseUrl}/admin/get-products';
  static const String deleteProduct = '${baseUrl}/admin/delete-products';
  static const String getAllOrders = '${baseUrl}/admin/get-orders';
  static const String changeOrderStatus = '${baseUrl}/admin/change-order-status';
  static const String analytics = '${baseUrl}/admin/analytics';


}