import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

final String apiUrl = 'https://www.lisheapp.co.ke/api/categories';

class TopMenus extends StatefulWidget {
  @override
  _TopMenusState createState() => _TopMenusState();
}

class _TopMenusState extends State<TopMenus> {
  List<Widget> menus = <Widget>[
    TopMenuTiles(name: "Lishe", imageUrl: "https://lisheapp.co.ke//storage/category/10/sR5lNQARyF4yQeNuz8kDOdAJ6tyPuXcAxqWaxp15.png", slug: ""),
    TopMenuTiles(name: "Snacks", imageUrl: "https://lisheapp.co.ke//storage/category/12/0QoavN8OIrypRqyzJ1QcLgRmLBGSX5f1XR0j33l8.png", slug: ""),
    TopMenuTiles(name: "Groceries", imageUrl: "https://lisheapp.co.ke//storage/category/3/jyEWy0tkc4w2nRx9FgGYQ0fXL7G3BvasPpWKnEPz.png", slug: ""),
    TopMenuTiles(name: "fast food", imageUrl: "https://lisheapp.co.ke//storage/category/11/VY7eEmJQrZobeQ7oNXzTxtAQqzcJthN1p3M4hHyR.png", slug: ""),
    TopMenuTiles(name: "Drinks", imageUrl: "https://lisheapp.co.ke//storage/category/4/cdnfqZ8PBpJQLgowGxWNrUM1YEgVZMiOcg6Qxx3O.png", slug: ""),
    TopMenuTiles(name: "Ready2eat", imageUrl: "https://lisheapp.co.ke//storage/category/5/zqitQe40zLPq8vQJU0DYmAxpcPaLo1NVdazyVILH.png", slug: "")
  ];

  Future<List<Widget>> getCountry() async {
    Uri countryUrl = Uri.parse(apiUrl);

    try {
      http.Response response = await http.get(countryUrl);
      Object decoded = jsonDecode(response.body);
      var dataJson = json.decode(response.body.toString());
      for (var i = 0; i < dataJson['data'].length; i++) {
        String nameRaw = dataJson['data'][i]['name'];
        String link = dataJson['data'][i]['image_url'];
        //print(link);
        menus.add(new TopMenuTiles(name: nameRaw,
            imageUrl: link,
            slug: ""));
      }
      return menus;
      //print(products);
    } catch (e) { throw(e); }
  }

  @override
  Widget build(BuildContext context) {
    getCountry();
    return Container(
      height: 100,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: menus,
      ),
    );
  }
}

class TopMenuTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String slug;

  TopMenuTiles(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.slug})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: new BoxDecoration(boxShadow: [
              new BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 25.0,
                offset: Offset(0.0, 0.75),
              ),
            ]),
            child: Card(
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(3.0),
                  ),
                ),
                child: Container(
                  width: 50,
                  height: 50,
                  child: Center(
                      child: Image.network(imageUrl,
                    width: 24,
                    height: 24,
                  )),
                )),
          ),
          Text(name,
              style: TextStyle(
                  color: Color(0xFF6e6e71),
                  fontSize: 14,
                  fontWeight: FontWeight.w400)),
        ],
      ),
    );
  }
}
