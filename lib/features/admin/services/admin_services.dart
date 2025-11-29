import 'dart:convert';
import 'dart:io';
import 'package:amazon_clone/constants/api_constant.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/global_keys.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/features/admin/models/sales.dart';
import 'package:amazon_clone/models/order.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class AdminServices {

  // Adding all the products .....
  Future<void> sellProducts({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,

  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {

      final cloudinary = CloudinaryPublic(GlobalKeys.cloudName, GlobalKeys.uploadPreset);
      List<String> imageUrls = [];

      for(int i=0; i<images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imageUrls.add(res.secureUrl);
      }
      
      Product product = Product(
          name: name,
          description: description,
          quantity: quantity,
          images: imageUrls,
          category: category,
          price: price
      );

      http.Response res = await http.post(
        Uri.parse(ApiConstants.addProduct),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );
      
      httpErrorHandle(
          response: res,
          onSuccess: () {
            showSnackBar(context, 'Product Added Successfully!');
            Navigator.pop(context);
          },
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

  }

  // Fetching all the products .....
  Future<List<Product>> fetchAllProducts(BuildContext context) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {

      http.Response res = await http.get(
        Uri.parse(ApiConstants.getAllProducts),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        }
      );
      
      httpErrorHandle(
          response: res,
          onSuccess: () {
            for(int i=0; i<jsonDecode(res.body).length; i++) {
              productList.add(
                  Product.fromJson(jsonEncode(jsonDecode(res.body)[i]))
              );
            }
          },
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return productList;

  }

  // Deleting the product .....
  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {

      http.Response res = await http.post(
        Uri.parse(ApiConstants.deleteProduct),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id,
        }),
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            onSuccess();
            // showSnackBar(context, 'Product Deleted Successfully!');
          },
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

  }

  // Fetching all the products .....
  Future<List<Order>> fetchAllOrders(BuildContext context) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];

    try {

      http.Response res = await http.get(
          Uri.parse(ApiConstants.getAllOrders),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          }
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            for(int i=0; i<jsonDecode(res.body).length; i++) {
              orderList.add(
                  Order.fromJson(jsonEncode(jsonDecode(res.body)[i]))
              );
            }
          },
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return orderList;

  }

  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {

      http.Response res = await http.post(
        Uri.parse(ApiConstants.changeOrderStatus),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': order.id,
          'status': status,
        }),
      );

      httpErrorHandle(
          response: res,
          onSuccess: onSuccess,
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

  }

  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int totalEarning = 0;

    try {

      http.Response res = await http.get(
          Uri.parse(ApiConstants.analytics),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          }
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            var response = jsonDecode(res.body);
            totalEarning = response['totalEarnings'];
            sales = [
              Sales('Mobiles', response['mobileEarnings']),
              Sales('Essentials', response['essentialEarnings']),
              Sales('Books', response['booksEarnings']),
              Sales('Appliances', response['applianceEarnings']),
              Sales('Fashion', response['fashionEarnings']),
            ];
          },
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return {
      'sales': sales,
      'totalEarnings': totalEarning,
    };

  }


}