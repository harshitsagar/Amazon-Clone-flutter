import 'dart:convert';
import 'package:amazon_clone/constants/api_constant.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class HomeServices {

  Future<List<Product>> fetchCategoryProducts({
    required BuildContext context,
    required String category
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {

      http.Response res = await http.get(
          Uri.parse(ApiConstants.getAllCategory(category)),
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

  Future<Product> fetchDealOfDay({
    required BuildContext context,
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Product product = Product(
        name: '',
        description: '',
        quantity: 0,
        images: [],
        category: '',
        price: 0
    );

    try {

      http.Response res = await http.get(
          Uri.parse(ApiConstants.getDealOfDay),
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': userProvider.user.token,
          }
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            product = Product.fromJson(res.body);
          },
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

    return product;

  }

}