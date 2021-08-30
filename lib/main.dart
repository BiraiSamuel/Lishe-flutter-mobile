// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/FoodDetailsPage.dart';
import 'package:flutter_app/pages/FoodOrderPage.dart';
import 'package:flutter_app/pages/HomePage.dart';
import 'package:flutter_app/pages/SignInPage.dart';
import 'package:flutter_app/pages/SignUpPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Roboto', hintColor: Color(0xFFd0cece)),
      home: HomePage(),
));

class CheckAuth extends StatefulWidget {
      @override
      _CheckAuthState createState() => _CheckAuthState();
}

class _CheckAuthState extends State<CheckAuth> {
      bool isAuth = false;
      @override
      void initState() {
            _checkIfLoggedIn();
            super.initState();
      }

      void _checkIfLoggedIn() async{
            SharedPreferences localStorage = await SharedPreferences.getInstance();
            var token = localStorage.getString('token');
            if(token != null){
                  setState(() {
                        isAuth = true;
                  });
            }
      }
      @override
      Widget build(BuildContext context) {
            Widget child;
            if (isAuth) {
                  child = HomePage();
            } else {
                  child = SignInPage();
            }
            return Scaffold(
                  body: child,
            );
      }
}