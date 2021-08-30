import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/animation/RotationRoute.dart';
import 'package:flutter_app/pages/WebPage.dart';
import 'package:flutter_app/Classes/WebData.dart';
import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

final data = WebData(
    text: "https://www.lisheapp.co.ke/lishe-menu");


class SearchWidget extends StatelessWidget {
  int id = 2;
  String urlLink = 'https://www.lisheapp.co.ke/lishe-menu';
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 10,top: 5,right: 10,bottom: 5),
      child: TextField(

        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(5.0)),
            borderSide: BorderSide(
              width: 0,
              color: Color(0xFFfb3132),
              style: BorderStyle.none,
            ),
          ),
          filled: true,
          prefixIcon: IconButton(icon: Icon(
            Icons.search,
            color: Color(0xFFfb3132),
          ),
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebPage(),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(
                    arguments: data,
                  ),
                ),
              );}),
          fillColor: Color(0xFFFAFAFA),
          suffixIcon: IconButton(icon: Icon(
            Icons.sort,
            color: Color(0xFFfb3132),
          ),
              onPressed: () {Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const WebPage(),
                  // Pass the arguments as part of the RouteSettings. The
                  // DetailScreen reads the arguments from these settings.
                  settings: RouteSettings(
                    arguments: data,
                  ),
                ),
              );}),
          hintStyle: new TextStyle(color: Color(0xFFd0cece), fontSize: 18),
          hintText: "What would your like to buy?",
        ),
      ),
    );
  }
}
