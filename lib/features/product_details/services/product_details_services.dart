import 'dart:convert';
import 'package:amazon_clone/constants/api_constant.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class ProductDetailsServices {

  Future<void> addToCart({
    required BuildContext context,
    required Product product,
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {

      http.Response res = await http.post(
        Uri.parse(ApiConstants.addToCart),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
        }),
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            User user = userProvider.user.copyWith(
              cart: jsonDecode(res.body)['cart']
            );
            userProvider.setUserFromModel(user);
          },
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

  }

  // Adding all the products .....
  Future<void> rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,

  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {

      http.Response res = await http.post(
        Uri.parse(ApiConstants.rateProduct),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({
          'id': product.id!,
          'rating': rating,
        }),
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {},
          context: context
      );

    } catch (e) {
      showSnackBar(context, e.toString());
    }

  }


}