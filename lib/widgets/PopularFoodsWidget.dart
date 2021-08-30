import 'package:flutter/material.dart';
import 'package:flutter_app/animation/RotationRoute.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/pages/FoodDetailsPage.dart';
import 'package:flutter_app/Classes/Todo.dart';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;

class PopularFoodsWidget extends StatefulWidget {
  @override
  _PopularFoodsWidgetState createState() => _PopularFoodsWidgetState();
}

final String apiUrl = 'https://www.lisheapp.co.ke/api/products?page=1';

class _PopularFoodsWidgetState extends State<PopularFoodsWidget> {

  @override
  void initState() {
    super.initState();
    //getCountry();
    //products = fetchAlbum();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 265,
      width: double.infinity,
      child: Column(
        children: <Widget>[
          PopularFoodTitle(),
          Expanded(
            child: PopularFoodItems(),
          )
        ],
      ),
    );
  }
}

class PopularFoodTiles extends StatelessWidget {
  int id;
  String name;
  String imageUrl;
  String rating;
  String type;
  String numberOfRating;
  String price;
  String slug;
  String description;
  List images;
  List variants;
  List options;

  PopularFoodTiles(
      {Key? key,
        required this.id,
      required this.name,
      required this.imageUrl,
      required this.rating,
        required this.type,
      required this.numberOfRating,
      required this.price,
        required this.description,
      required this.slug,
      required this.images,
      required this.variants,
        required this.options})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(
          builder: (context) => InheritDetailsPage(),
          // Pass the arguments as part of the RouteSettings. The
          // DetailScreen reads the arguments from these settings.
          settings: RouteSettings(
            arguments: Todo(id, name, description, type, price, images, variants, options),
          ),
        ),
        );
      },
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
                color: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(5.0),
                  ),
                ),
                child: Container(
                  width: 170,
                  height: 210,
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: Container(
                              alignment: Alignment.topRight,
                              width: double.infinity,
                              padding: EdgeInsets.only(right: 5, top: 5),
                              child: Container(
                                height: 28,
                                width: 28,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white70,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color(0xFFfae3e2),
                                        blurRadius: 25.0,
                                        offset: Offset(0.0, 0.75),
                                      ),
                                    ]),
                                child: Icon(
                                  Icons.favorite,
                                  color: Color(0xFFfb3132),
                                  size: 16,
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Center(
                                child: Image.network(imageUrl,
                              width: 130,
                              height: 140,
                            )),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5),
                            child: Text(name,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500)),
                          ),
                          Container(
                            alignment: Alignment.topRight,
                            padding: EdgeInsets.only(right: 5),
                            child: Container(
                              height: 28,
                              width: 28,
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white70,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Color(0xFFfae3e2),
                                      blurRadius: 25.0,
                                      offset: Offset(0.0, 0.75),
                                    ),
                                  ]),
                              child: Icon(
                                Icons.near_me,
                                color: Color(0xFFfb3132),
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text(rating,
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                              ),
                              Container(
                                padding: EdgeInsets.only(top: 3, left: 5),
                                child: Row(
                                  children: <Widget>[
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFFfb3132),
                                    ),
                                    Icon(
                                      Icons.star,
                                      size: 10,
                                      color: Color(0xFF9b9b9c),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.topLeft,
                                padding: EdgeInsets.only(left: 5, top: 5),
                                child: Text("($numberOfRating)",
                                    style: TextStyle(
                                        color: Color(0xFF6e6e71),
                                        fontSize: 10,
                                        fontWeight: FontWeight.w400)),
                              ),
                            ],
                          ),
                          Container(
                            alignment: Alignment.bottomLeft,
                            padding: EdgeInsets.only(left: 5, top: 5, right: 5),
                            child: Text(price,
                                style: TextStyle(
                                    color: Color(0xFF6e6e71),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600)),
                          )
                        ],
                      )
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}

class PopularFoodTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            "Popular Foods",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xFF3a3a3b),
                fontWeight: FontWeight.w300),
          ),
          Text(
            "See all",
            style: TextStyle(
                fontSize: 16, color: Colors.blue, fontWeight: FontWeight.w100),
          )
        ],
      ),
    );
  }
}

class PopularFoodItems extends StatelessWidget {
  List<Widget> products = <Widget>[
    PopularFoodTiles(
        id: 1,
        name: "Goat Meat",
        imageUrl: 'https://lisheapp.co.ke//storage/product/2/PYq6CPzwUli8KUV6M0Vj0Be8Gk5JCzdWvUbpvtOX.jpg',
        rating: '4.9',
        type: 'simple',
        numberOfRating: '200',
        price: 'KES 8500',
        description: "Fresh Goat Meat",
        slug: "goat_meat",
        images: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
        variants: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
        options: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
    ),
    PopularFoodTiles(
        id: 2,
        name: "Sweet Banana",
        imageUrl: 'https://lisheapp.co.ke//storage/product/7/I12WQO778FL0Soj2ZoThCVmTF2IdCtA8kUy0R3i8.jpg',
        rating: "4.5",
        type: 'simple',
        numberOfRating: "100",
        price: "KES 125",
        description: "Fresh bananas",
        slug: "sweet_banana",
      images: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
      variants: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
      options: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
    ),
    PopularFoodTiles(
        id: 3,
        name: "Coconut",
        imageUrl: 'https://lisheapp.co.ke//storage/product/100/c6YCUO4YqHC5GWfT8aifHrOQxLaydNkJ0ej9e279.jpg',
        rating: "4.0",
        type: 'simple',
        numberOfRating: "50",
        price: "KES 150",
        description: "Fresh Coconuts",
        slug: "",
      images: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
      variants: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
      options: [{"id":53,"path":"product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","original_image_url":"https:\/\/lisheapp.co.ke\/\/storage\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","small_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/small\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","medium_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/medium\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg","large_image_url":"https:\/\/www.lisheapp.co.ke\/cache\/large\/product\/115\/yM0ezpOSgCQxeJ27hs2u8hsa1FTB4K7seWGko40n.jpg"}],
    ),
  ];

  String smallSentence(String bigSentence){
    if(bigSentence.length > 15){
      return bigSentence.substring(0,15) + '...';
    }
    else{
      return bigSentence;
    }
  }

  Future<List> getCountry() async {
    Uri countryUrl = Uri.parse(apiUrl);

    try {
      http.Response response = await http.get(countryUrl);
      Object decoded = jsonDecode(response.body);
      var dataJson = json.decode(response.body.toString());
      for (var i = 0; i < dataJson['data'].length; i++) {
        String prices = dataJson['data'][i]['formated_price'];
        int id = dataJson['data'][i]['id'];
        String type = dataJson['data'][i]['type'];
        String nameRaw = smallSentence(dataJson['data'][i]['name']);
        String description = dataJson['data'][i]['description'];
        String rawRating = dataJson['data'][i]['reviews']['average_rating'].toString();
        var urlImage = dataJson['data'][i]['images'][0];
        String link = urlImage['url'].toString();
        var customizations = dataJson['data'][i]['variants'];
        var optiones = dataJson['data'][i]['super_attributes']?[0]['options'];
        //print(optiones);
        String totalRating = dataJson['data'][i]['reviews']['total'].toString();
        String skuRaw = dataJson['data'][i]['sku'];
        products.add(new PopularFoodTiles(id: id,
            name: nameRaw,
            imageUrl: link,
            rating: rawRating,
            type: type,
            numberOfRating: totalRating,
            price: prices,
            description: description,
            slug: skuRaw,
            images: [urlImage],
            variants: customizations,
            options: optiones));
      }
      return products;
      //print(products);
    } catch (e) { throw(e); }
  }
  var itemProducts = <Widget>[];

  @override
  Widget build(BuildContext context) {
    getCountry();
    return ListView(
      scrollDirection: Axis.horizontal,
      children: products,
    );
  }
}