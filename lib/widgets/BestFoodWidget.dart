import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter_app/pages/WebPage.dart';
import 'package:flutter_app/Classes/WebData.dart';

import 'package:http/http.dart' as http;

final String apiUrl = 'https://www.lisheapp.co.ke/api/sliders';

class BestFoodWidget extends StatefulWidget {
  @override
  _BestFoodWidgetState createState() => _BestFoodWidgetState();
}

class _BestFoodWidgetState extends State<BestFoodWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          BestFoodTitle(),
          Expanded(
            child: BestFoodList(),
          )
        ],
      ),
    );
  }
}

class BestFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Best Online Food Stores",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300),
          ),
        ],
      ),
    );
  }
}

class BestFoodTiles extends StatelessWidget {
  String name;
  String imageUrl;
  String rating;
  String numberOfRating;
  String price;
  String slug;
  String menuLink;

  BestFoodTiles(
      {Key? key,
      required this.name,
      required this.imageUrl,
      required this.rating,
      required this.numberOfRating,
      required this.price,
      required this.slug,
      required this.menuLink})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final data = WebData(
        text: menuLink);
    return InkWell(
      onTap: () {Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const WebPage(),
          // Pass the arguments as part of the RouteSettings. The
          // DetailScreen reads the arguments from these settings.
          settings: RouteSettings(
            arguments: data,
          ),
        ),
      ); },
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 10, right: 5, top: 5, bottom: 5),
            decoration: BoxDecoration(boxShadow: [
              /* BoxShadow(
                color: Color(0xFFfae3e2),
                blurRadius: 15.0,
                offset: Offset(0, 0.75),
              ),*/
            ]),
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.network(imageUrl,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              elevation: 1,
              margin: EdgeInsets.all(5),
            ),
          ),
        ],
      ),
    );
  }
}

class BestFoodList extends StatelessWidget {
  List<Widget> bestFoodsTiles = <Widget>[
    BestFoodTiles(
        name: "Gracia eateries",
        imageUrl: "https://lisheapp.co.ke//storage/slider_images/Gracia Eateries/ElFxgD8z57xvPgWxe2BVKGTSjWyZPuAf3WkyNx1K.jpg",
        rating: '4.9',
        numberOfRating: '200',
        price: '15.06',
        slug: "fried_egg",
        menuLink: "https://www.graciaeateries.lisheapp.co.ke/lishe-menu",),
    BestFoodTiles(
        name: "Mixed vegetable",
        imageUrl: "https://lisheapp.co.ke//storage/slider_images/Lishe/LiMVgXW9psJQuBPtASch2F6eSGxRxs7zTCAZZlj1.jpg",
        rating: "4.9",
        numberOfRating: "100",
        price: "17.03",
        slug: "",
        menuLink: "https://www.lisheapp.co.ke/lishe-menu"),
    BestFoodTiles(
        name: "Salads",
        imageUrl: "https://lisheapp.co.ke//storage/slider_images/soko jamu/E2I4GNrPAEcjiAkaLaByMqdEjxRO2G5MUQNGarZ3.jpg",
        rating: "4.0",
        numberOfRating: "50",
        price: "11.00",
        slug: "",
        menuLink: "https://www.lisheapp.co.ke/lishe-menu"),
  ];

  Future<List<Widget>> getCountry() async {
    Uri countryUrl = Uri.parse(apiUrl);

    try {
      http.Response response = await http.get(countryUrl);
      Object decoded = jsonDecode(response.body);
      var dataJson = json.decode(response.body.toString());
      for (var i = 0; i < dataJson['data'].length; i++) {
        String nameRaw = dataJson['data'][i]['title'];
        String link = dataJson['data'][i]['image_url'];
        //print(dataJson['data'][i]);
        bestFoodsTiles.add(new BestFoodTiles(name: nameRaw,
            imageUrl: link,
            rating: "4.0",
            numberOfRating: "50",
            price: "11.00",
            slug: "",
            menuLink: "https://www.lisheapp.co.ke/lishe-menu"));
      }
      return bestFoodsTiles;
      //print(products);
    } catch (e) { throw(e); }
  }
  @override
  Widget build(BuildContext context) {
    getCountry();
    return ListView(
      children: bestFoodsTiles,
    );
  }
}

Future fetchAlbum() async {
  final String apiUrl = 'https://www.lisheapp.co.ke/api/products?page=1';
  final response = await http.get(Uri.parse(apiUrl));
  var dataJson = json.decode(response.body.toString());

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return dataJson['data'];
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}