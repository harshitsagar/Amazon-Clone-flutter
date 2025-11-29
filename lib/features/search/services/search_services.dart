import 'dart:convert';
import 'package:amazon_clone/constants/api_constant.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/product_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class SearchServices {

  Future<List<Product>> fetchSearchedProducts({
    required BuildContext context,
    required String searchQuery,
  }) async {

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];

    try {

      http.Response res = await http.get(
          Uri.parse(ApiConstants.getAllSearchedCategory(searchQuery)),
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

}