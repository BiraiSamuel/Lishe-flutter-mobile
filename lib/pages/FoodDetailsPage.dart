import 'package:flutter/material.dart';
import 'package:flutter_app/animation/ScaleRoute.dart';
import 'package:flutter_app/pages/FoodOrderPage.dart';
import 'package:flutter_app/widgets/FoodDetailsSlider.dart';
import 'package:flutter_app/Classes/Todo.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_app/views/count_state.dart';

late Todo todo;

class InheritDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    todo = ModalRoute.of(context)!.settings.arguments as Todo;
    return Scaffold(
      body: CountProvider(
        counter: Counter(1),
        child: FoodDetailsPage(),
      ),
    );
  }
}

final String apiUrl = 'https://www.lisheapp.co.ke/api/checkout/cart/add/';

class FoodDetailsPage extends StatefulWidget {

  @override
  _FoodDetailsPageState createState() => _FoodDetailsPageState();
}

class _FoodDetailsPageState extends State<FoodDetailsPage> {
  var counterProvider;
  void _incrementCounter() {
    setState(() {
      counterProvider.counter.increment();
    });
  }

  void _decrementCounter() {
    setState(() {
      counterProvider.counter.decrement();
    });
  }
  final currencyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // Create storage
  final storage = new FlutterSecureStorage();
  int counter = 1;

  String selectedCurrency = "";

  bool isDebug = true;
  @override
  Widget build(BuildContext context) {
    this.currencyController.text = this.selectedCurrency;
    counterProvider = CountProvider.of(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Color(0xFFFAFAFA),
          elevation: 0,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Color(0xFF3a3737),
            ),
            onPressed: () => Navigator.of(context).pop(),
          ),
          brightness: Brightness.light,
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.business_center,
                  color: Color(0xFF3a3737),
                ),
                onPressed: () {
                  Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
                })
          ],
        ),
        body: SingleChildScrollView(
    child: Container(
          padding: EdgeInsets.only(
            left: 15,
            right: 15,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Card(
                semanticContainer: true,
                clipBehavior: Clip.antiAliasWithSaveLayer,
                child: Image.network(
                  todo.images[0]['url'].toString(),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3.0),
                ),
                elevation: 1,
                margin: EdgeInsets.all(5),
              ),
              /*  Container(
                height: 150,
                child:FoodDetailsSlider(
                    slideImage1: "assets/images/bestfood/ic_best_food_8.jpeg",
                    slideImage2: "assets/images/bestfood/ic_best_food_9.jpeg",
                    slideImage3: "assets/images/bestfood/ic_best_food_10.jpeg"),
              ),*/

              FoodTitleWidget(
                  productName: todo.title,
                  productPrice: todo.price,
                  productHost: "Lishe"),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    IconButton(
                      onPressed: () {_decrementCounter();},
                      icon: Icon(Icons.remove),
                      color: Colors.black,
                      iconSize: 30,
                    ),
                    InkWell(
                      onTap: () async {
                        // Read value
                        String? token = await storage.read(key: 'jwt');
                        if (todo.type == 'simple') {
                          final response = await addToCart(todo.id, token, counterProvider.counter.count);
                          //print(response.body);
                          var dataJson = json.decode(response.body.toString());
                          //print(dataJson['message']);
                          if(dataJson['message'] == "Item was successfully added to cart."){
                            Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
                          }
                        }else{
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  content: Stack(
                                    overflow: Overflow.visible,
                                    children: <Widget>[
                                      Positioned(
                                        right: -40.0,
                                        top: -40.0,
                                        child: InkResponse(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: CircleAvatar(
                                            child: Icon(Icons.close),
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Form(
                                        key: _formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                                              child: TextFormField(
                                                controller: this.currencyController,
                                                textInputAction: TextInputAction.next,
                                                style: TextStyle(color: Colors.black),
                                                readOnly: true,
                                                onTap: this._openBottomSheet,
                                                decoration: InputDecoration(
                                                  hintText: "Customizations",
                                                ),
                                                validator: (value) =>
                                                value!.isNotEmpty ? null : "Customizations based on variants is required",
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: Text('Please select custom variants for item'),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: RaisedButton(
                                                child: Text("Submitß"),
                                                onPressed: () async {
                                                  if (_formKey.currentState!.validate()) {
                                                    _formKey.currentState!.save();
                                                    this.showLoading("Please wait!");
                                                    final response = await addConfigurableToCart(todo.id, token, this.selectedCurrency, todo.options, todo.variants, counterProvider.counter.count);
                                                    print(response.body);
                                                    var dataJson = json.decode(response.body.toString());
                                                    if(dataJson['message'] == "Item was successfully added to cart."){
                                                      Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
                                                    }else{
                                                      this.showLoading(dataJson['error'].toString());
                                                    }
                                                  }
                                                },
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        }
                      },
                      child: Container(
                        width: 200.0,
                        height: 45.0,
                        decoration: new BoxDecoration(
                          color: Color(0xFFfd2c2c),
                          border: Border.all(color: Colors.white, width: 2.0),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Center(
                          child: Text(
                            'Add ' + counterProvider.counter.count.toString() +' To Bag',
                            style: new TextStyle(
                                fontSize: 18.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {_incrementCounter();},
                      icon: Icon(Icons.add),
                      color: Color(0xFFfd2c2c),
                      iconSize: 30,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              PreferredSize(
                preferredSize: Size.fromHeight(50.0),
                child: TabBar(
                  labelColor: Color(0xFFfd3f40),
                  indicatorColor: Color(0xFFfd3f40),
                  unselectedLabelColor: Color(0xFFa4a1a1),
                  indicatorSize: TabBarIndicatorSize.label,
                  labelStyle: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      text: 'Food Details',
                    ),
                    Tab(
                      text: 'Food Reviews',
                    ),
                  ], // list of tabs
                ),
              ),
              Container(
                height: 150,
                child: TabBarView(
                  children: [
                    Container(
                      color: Colors.white24,
                      child: DetailContentMenu(),
                    ),
                    Container(
                      color: Colors.white24,
                      child: DetailContentMenu(),
                    ), // class name
                  ],
                ),
              ),
              BottomMenu(),
            ],
          ),
        ),
      )),
    );
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getCurrency();
        });
  }

  Widget _getCurrency() {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;
    List variante = [];
    //print(todo.options);

    for(var i = 0; i < todo.variants.length; i++){
      variante.add('ID: ' + todo.variants[i]['id'].toString() + ' ~ Variant: ' + todo.variants[i]['name']);
    }
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: variante
            .map((currency) => ListTile(
          onTap: () => {this._handleCurrencyTap(currency)},
          title: Column(
            children: [
              Text(
                currency,
                textAlign: TextAlign.start,
                style: TextStyle(color: Colors.black),
              ),
              SizedBox(height: 4),
              Divider(height: 1)
            ],
          ),
        ))
            .toList(),
      ),
    );
  }

  _handleCurrencyTap(String currency) {
        this.setState(() {
        this.selectedCurrency = currency;
        this.currencyController.text = currency;
        });
  }

  Future<void> showLoading(String message) {
    return showDialog(
      context: this.context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Container(
            margin: EdgeInsets.fromLTRB(30, 20, 30, 20),
            width: double.infinity,
            height: 50,
            child: Text(message),
          ),
        );
      },
    );
  }
}

class FoodTitleWidget extends StatelessWidget {
  String productName;
  String productPrice;
  String productHost;

  FoodTitleWidget({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productHost,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              productName,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
            Text(
              productPrice,
              style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF3a3a3b),
                  fontWeight: FontWeight.w500),
            ),
          ],
        ),
        SizedBox(
          height: 5,
        ),
        Row(
          children: <Widget>[
            Text(
              "by ",
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFFa9a9a9),
                  fontWeight: FontWeight.w400),
            ),
            Text(
              productHost,
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF1f1f1f),
                  fontWeight: FontWeight.w400),
            ),
          ],
        )
      ],
    );
  }
}

class BottomMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Column(
            children: <Widget>[
              Icon(
                Icons.timelapse,
                color: Color(0xFF404aff),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "12pm-3pm",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions,
                color: Color(0xFF23c58a),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "3.5 km",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.map,
                color: Color(0xFFff0654),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Map View",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
          Column(
            children: <Widget>[
              Icon(
                Icons.directions_bike,
                color: Color(0xFFe95959),
                size: 35,
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                "Delivery",
                style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFFa9a9a9),
                    fontWeight: FontWeight.w300),
              )
            ],
          ),
        ],
      ),
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  int counter = 1;
  @override
  Widget build(BuildContext context) {
    final todo = ModalRoute.of(context)!.settings.arguments as Todo;
    // Create storage
    final storage = new FlutterSecureStorage();
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {counter--;},
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 30,
          ),
          InkWell(
            onTap: () async {
              if (todo.type == 'simple') {
                // Read value
                String? token = await storage.read(key: 'jwt');
                final response = await addToCart(todo.id, token, counter);
                //print(response.body);
                var dataJson = json.decode(response.body.toString());
                //print(dataJson['message']);
                if(dataJson['message'] == "Item was successfully added to cart."){
                  Navigator.push(context, ScaleRoute(page: FoodOrderPage()));
                }
              }else{
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Stack(
                          overflow: Overflow.visible,
                          children: <Widget>[
                            Positioned(
                              right: -40.0,
                              top: -40.0,
                              child: InkResponse(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: CircleAvatar(
                                  child: Icon(Icons.close),
                                  backgroundColor: Colors.red,
                                ),
                              ),
                            ),
                            Form(
                              key: _formKey,
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: RaisedButton(
                                      child: Text("Submitß"),
                                      onPressed: () {
                                        if (_formKey.currentState!.validate()) {
                                          _formKey.currentState!.save();
                                        }
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
              }
            },
            child: Container(
              width: 200.0,
              height: 45.0,
              decoration: new BoxDecoration(
                color: Color(0xFFfd2c2c),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Center(
                child: Text(
                  'Add To Bag',
                  style: new TextStyle(
                      fontSize: 18.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {counter++;},
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: 30,
          ),
        ],
      ),
    );
  }
}

class DetailContentMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        todo.description,
        style: TextStyle(
            fontSize: 14.0,
            color: Colors.black87,
            fontWeight: FontWeight.w400,
            height: 1.50),
        textAlign: TextAlign.justify,
      ),
    );
  }
}

Future<http.Response> addToCart(int id, String? token, int counter) {
  String ide = id.toString();
  String quantity = counter.toString();
  Uri countryUrl = Uri.parse(apiUrl + id.toString() + '?token=true');
  // print(countryUrl);
  return http.post(
    countryUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(<String, String>{
      'quantity': quantity,
      'is_configurable': "is_configurable",
      'product_id': ide
    }),
  );
}

Future<http.Response> addConfigurableToCart(int id, String? token, String variantId, List options, List variants, int counter) {
  String ide = id.toString();
  Uri countryUrl = Uri.parse(apiUrl + id.toString() + '?token=true');
  String aStr = variantId.replaceAll(new RegExp(r'[^0-9]'),'');
  Map<String, dynamic> variations = {};
  for(var i = 0; i < variants.length; i++){
    String ide = variants[i]['id'].toString();
    variations[ide] = options[i]['id'].toString();
  }
  String quantity = counter.toString();
  var body = json.encode(variations);
  return http.post(
    countryUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(<String, String>{
      'quantity': quantity,
      'product_id': id.toString(),
      'is_configurable': "true",
      'selected_configurable_option': aStr,
      'super_attribute': body
    }),
  );
}
