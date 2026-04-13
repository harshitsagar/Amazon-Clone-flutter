import 'dart:convert';

import 'package:amazon_clone/common/widgets/bottom_bar.dart';
import 'package:amazon_clone/constants/api_constant.dart';
import 'package:amazon_clone/constants/error_handling.dart';
import 'package:amazon_clone/constants/utils.dart';
import 'package:amazon_clone/models/user_model.dart';
import 'package:amazon_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  // Sign up user .....
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    // Your sign up logic here
    try {
      User user = User(
        id: '',
        name: name,
        email: email,
        password: password,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse(ApiConstants.signUp),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
          response: res,
          onSuccess: () {
            showSnackBar(context, 'Account created! Login with the same credentials');
          },
          context: context
      );
    } catch (e) {
      // Handle errors here....
      showSnackBar(context, e.toString());
    }
  }

  // Sign in user .....
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    // Your sign up logic here
    try {

      http.Response res = await http.post(
        Uri.parse(ApiConstants.signIn),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      print(res.body);

      httpErrorHandle(
          response: res,
          onSuccess: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            Provider.of<UserProvider>(context, listen: false).setUser(res.body);
            await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);
            Navigator.pushNamedAndRemoveUntil(context, BottomBar.routeName, (route) => false);
            // showSnackBar(context, 'Logged in successfully');
          },
          context: context
      );
    } catch (e) {
      // Handle errors here....
      showSnackBar(context, e.toString());
    }
  }

  // get User Data .....
  void getUserData({
    BuildContext? context,
  }) async {

    try {

      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      if(token == null){
        prefs.setString('x-auth-token', '');
      }

      // Validate the token .....
      var tokenRes = await http.post(
        Uri.parse(ApiConstants.tokenIsValid),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
      );

      var response = jsonDecode(tokenRes.body);

      if(response == true){
        // get the user data .....
        http.Response userRes = await http.get(
          Uri.parse(ApiConstants.getUserData),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        var userProvider = Provider.of<UserProvider>(context!, listen: false);
        userProvider.setUser(userRes.body);
      }

    } catch (e) {
      // Handle errors here....
      showSnackBar(context!, e.toString());
    }
  }

  void updateUserType({
    required BuildContext context,
    required String type,
  }) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('x-auth-token');

      http.Response res = await http.post(
        Uri.parse(ApiConstants.updateUserType),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token!,
        },
        body: jsonEncode({
          'type': type,
        }),
      );

      httpErrorHandle(
        response: res,
        onSuccess: () {
          User user = Provider.of<UserProvider>(context, listen: false)
              .user
              .copyWith(type: type);
          Provider.of<UserProvider>(context, listen: false).setUserFromModel(user);
        },
        context: context,
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
