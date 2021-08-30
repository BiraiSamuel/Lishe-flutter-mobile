import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_app/Classes/Webservice.dart';
import 'package:flutterwave/flutterwave.dart';
import 'package:flutter_app/Classes/Todo.dart';

import 'package:flutter_app/views/count_state.dart';

late Todo todo;

class InheritOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    todo = ModalRoute.of(context)!.settings.arguments as Todo;
    return Scaffold(
      body: CountProvider(
        counter: Counter(1),
        child: FoodOrderPage(),
      ),
    );
  }
}


final String apiUrl = 'https://www.lisheapp.co.ke/api/checkout/cart?token=true';
final String shippingApi = 'https://www.lisheapp.co.ke/api/checkout/save-address?token=true';
final String removeUrl = 'https://www.lisheapp.co.ke/api/checkout/cart/remove-item/';
final String checkoutUrl = 'https://www.lisheapp.co.ke/api/checkout/save-order?token=true';
final String editCart = 'https://www.lisheapp.co.ke/api/checkout/cart/update';
String total = '0';String name = ''; String email = ''; String currency = 'KES'; String jwtToken = '';
String intTotal = '0'; Map<String, dynamic> customerAddressData = {};

class FoodOrderPage extends StatefulWidget {
  @override
  _FoodOrderPageState createState() => _FoodOrderPageState();
}

Future<List<Widget>> fetchPost() async {
  // Create storage
  final storage = new FlutterSecureStorage();
  // Read value
  String? token = await storage.read(key: 'jwt');

  if(token != null){
    final response = await http.get(Uri.parse(apiUrl), headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    });
    var existingCart = json.decode(response.body);
    customerAddressData = existingCart['data']['shipping_address'];
    if (response.statusCode == 200) {
      Iterable list = existingCart['data']['items'];
      List<Widget> listing = <Widget>[];
      for(var i = 0; i < list.length; i++){
        print(list);
      }
      total = existingCart['data']['formated_grand_total'];
      intTotal = existingCart['data']['grand_total'];
      currency = existingCart['data']['cart_currency_code'];
      email = existingCart['data']['customer_email'];
      return list.map((model) => CartItem.fromJson(model)).toList();
    } else {
      throw Exception('Failed to load post');
    }
  }else{
    throw Exception('Please login first');
  }
}

class _FoodOrderPageState extends State<FoodOrderPage> {
  int counter = 3;
  var counterProvider;
  // Create storage
  final storage = new FlutterSecureStorage();
  final formKey = GlobalKey<FormState>();
  final amountController = TextEditingController();
  final currencyController = TextEditingController();
  final narrationController = TextEditingController();
  final publicKeyController = TextEditingController();
  final encryptionKeyController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();

  late Future<List<Widget>> futureAlbum;

  String selectedCurrency = "";

  bool isDebug = true;
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

  @override
  void initState() {
    _checkIfLoggedIn();
    super.initState();
  }

  void _checkIfLoggedIn() async{
      setState(() => {
        futureAlbum = fetchPost()
      });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    counterProvider = CountProvider.of(context);
    //print(counterProvider.counter.count);
    return Scaffold(
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
          title: Center(
            child: Text(
              "Item Carts",
              style: TextStyle(
                  color: Color(0xFF3a3737),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          brightness: Brightness.light,
          actions: <Widget>[
              Stack(
              children: <Widget>[
              IconButton(
              icon: Icon(
              Icons.business_center,
                color: Color(0xFF3a3737),
              ),
              onPressed: () {this._onPressed();}),
          counter != 0
          ? Positioned(
          right: 11,
          top: 11,
          child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(6),
          ),
          constraints: BoxConstraints(
          minWidth: 14,
          minHeight: 14,
          ),
          child: Text(
          '$counter',
          style: TextStyle(
          color: Colors.red,
          fontSize: 8,
          ),
          textAlign: TextAlign.center,
          ),
          ),
          )
              : Container()
          ],
          ),
          ],
        ),
        body: SingleChildScrollView(
        child: Container(
        padding: EdgeInsets.all(15),
        child: Form(
          key: this.formKey,
          child: ListView(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            children: <Widget>[
              Visibility (
                visible: false,
                child: Container(
                  margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                  child: TextFormField(
                    controller: this.amountController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(hintText: "Amount"),
                  ),
                ),
              ),
              Visibility (
                visible: false,
                child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.currencyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  readOnly: true,
                  onTap: (){},
                  decoration: InputDecoration(
                    hintText: "Currency",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Currency is required",
                ),
              ),),
              Visibility (
                visible: false,
                child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.publicKeyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Public Key",
                  ),
                ),
              ),),
              Visibility (
                visible: false,
                child:Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.encryptionKeyController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Encryption Key",
                  ),
                ),
              ),),
          Visibility (
            visible: false,
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.emailController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Email is required",
                ),
              ),),
          Visibility (
            visible: false,
            child: Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: TextFormField(
                  controller: this.phoneNumberController,
                  textInputAction: TextInputAction.next,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: "Phone Number",
                  ),
                  validator: (value) =>
                  value!.isNotEmpty ? null : "Phone Number is required",
                ),
              ),),
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.width,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: FutureBuilder<List<Widget>>(
                  future: futureAlbum,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return createCountriesListView(context, snapshot);
                    } else if (snapshot.hasError) {
                      print(('Error: ${snapshot.error}'));
                      return Text('Please login first!');
                    }

                    // By default, show a loading spinner.
                    return CircularProgressIndicator();
                  },
                ),
              ),
              PromoCodeWidget(),
              SizedBox(
                height: 10,
              ),
              TotalCalculationWidget(),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.only(left: 5),
                child: Text(
                  "Payment Method",
                  style: TextStyle(
                      fontSize: 20,
                      color: Color(0xFF3a3a3b),
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              PaymentMethodWidget(),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.fromLTRB(0, 20, 0, 10),
                child: RaisedButton(
                  onPressed: this._onPressed,
                  color: Colors.blue,
                  child: Text(
                    "Make Payment",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        ), ));
  }

  String selectedCountry = "AF";

  Widget createCountriesListView(BuildContext context, AsyncSnapshot snapshot) {
    var values = snapshot.data;
    return ListView.builder(
      itemCount: values == null ? 0 : values.length,
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        //counterProvider = values[index].productCartQuantity;
        return CountProvider(
            counter: Counter(int.parse(values[index].productCartQuantity)),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCountry = values[index].productName;
                });
                // print(values[index].productPrice);
                // print(selectedCountry);
              },
              child: Column(
                children: <Widget>[
                  new CartItem(
                      productName: values[index].productName,
                      productPrice: values[index].productPrice,
                      productImage: values[index].productImage,
                      productCartQuantity: values[index].productCartQuantity,
                      productId: values[index].productId),
                  Divider(
                    height: 2.0,
                  ),
                ],
              ),
            ),
          );
      },
    );
  }

  Widget createLoginView(BuildContext context, AsyncSnapshot snapshot) {
    final _formKey = GlobalKey<FormState>();
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
    return Text('Please login first');
  }

  _onPressed() {
    final _formKey = GlobalKey<FormState>();
    bool value = true;
    final List<String> textFieldsValue = [];
    if (customerAddressData != null) {
      //print(customerAddressData['name']);
      this._handlePaymentInitialization();
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
                          child: Text("Enter shipping address"),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              textFieldsValue.add(value!);
                              return ;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter county'
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              textFieldsValue.add(value!);
                              return ;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter city address'
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: TextFormField(
                            validator: (value) {
                              textFieldsValue.add(value!);
                              return ;
                            },
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Enter phone'
                            ),
                          ),
                        ),
                        Text(
                          'Shipping address is same as billing: ',
                          style: TextStyle(fontSize: 17.0),
                        ), //Text
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Checkbox(
                            value: value,
                            onChanged: (bool? value) {
                              setState(() {
                                value = value;
                              });
                            },
                          ), //Checkbox
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RaisedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                this.showLoading("Please wait!");
                                print(textFieldsValue);
                                final response = await addShippingToCart(textFieldsValue);
                                print(response);
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
  }

  Future<String> addShippingToCart(List address) async {
    String? token = await storage.read(key: 'jwt');
    String? email = await storage.read(key: 'email');
    String? first_name = await storage.read(key: 'first_name');
    String? last_name = await storage.read(key: 'last_name');
    String city = address[0];
    String state = address[1];
    String phone = address[2];
    Map demo = {
      "billing": {
        "address1": {
          "0": "H 23"
        },
        "use_for_shipping": "true",
        "first_name": first_name,
        "last_name": last_name,
        "email": email,
        "city": city,
        "state": state,
        "postcode": "00100",
        "country": "KE",
        "phone": phone
      },
      "shipping": {
        "address1": {
          "0": ""
        }
      }
    };
    //var body = json.encode(variations);
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(shippingApi));
    request.headers.set('content-type', 'application/json');
    request.headers.set('Accept', 'application/json');
    request.headers.set('Authorization', 'Bearer $token');
    request.add(utf8.encode(json.encode(demo)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    httpClient.close();
    return reply;
  }

  _handlePaymentInitialization() async {
    final flutterwave = Flutterwave.forUIPayment(
        amount: intTotal,
        currency: 'KES',
        context: this.context,
        publicKey: 'FLWPUBK-3a0514e7e9579bfe1e7a888a2cd1398c-X',
        encryptionKey: '2aa9cbd60bfc45d3bc29bff2',
        email: 'biraisamuel16@gmail.com',
        fullName: "Birai Samuel",
        txRef: DateTime.now().toIso8601String(),
        narration: "lISHEAPP",
        isDebugMode: false,
        phoneNumber: '0716261608',
        acceptAccountPayment: true,
        acceptCardPayment: true,
        acceptUSSDPayment: true
    );
    final response = await flutterwave.initializeForUiPayments();
    // Create storage
    final storage = new FlutterSecureStorage();
    // Read value
    String? token = await storage.read(key: 'jwt');
    //print(token);
    if( /**token != null && response != null**/ true ) {
      final responsee = await http.post(Uri.parse(checkoutUrl),headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });
      //print(responsee.body);
      if (responsee.statusCode == 200) {
        //print(responsee.body);
        //this.showLoading(response!.data!.status!);
        return json.encode(responsee);
      } else {
        //this.showLoading(response!.data!.status!);
        throw Exception('Failed to load data!');
      }
    }else{
      this.showLoading("No Response!");
      throw Exception('Failed to load data!');
    }
  }

  void _openBottomSheet() {
    showModalBottomSheet(
        context: this.context,
        builder: (context) {
          return this._getCurrency();
        });
  }

  Widget _getCurrency() {
    final currencies = [
      FlutterwaveCurrency.UGX,
      FlutterwaveCurrency.GHS,
      FlutterwaveCurrency.NGN,
      FlutterwaveCurrency.RWF,
      FlutterwaveCurrency.KES,
      FlutterwaveCurrency.XAF,
      FlutterwaveCurrency.XOF,
      FlutterwaveCurrency.ZMW
    ];
    return Container(
      height: 250,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      color: Colors.white,
      child: ListView(
        children: currencies
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
    Navigator.pop(this.context);
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

class PaymentMethodWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 60,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
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
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 10, right: 30, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Container(
                alignment: Alignment.center,
                child: Image.asset(
                  "assets/images/menus/ic_credit_card.png",
                  width: 50,
                  height: 50,
                ),
              ),
              Text(
                "Credit/Debit Card",
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF3a3a3b),
                    fontWeight: FontWeight.w400),
                textAlign: TextAlign.left,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class TotalCalculationWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.1),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
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
          alignment: Alignment.center,
          padding: EdgeInsets.only(left: 25, right: 30, top: 10, bottom: 10),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Grilled Salmon",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "\$192",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Meat vegetable",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    "\$102",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Total",
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    total,
                    style: TextStyle(
                        fontSize: 18,
                        color: Color(0xFF3a3a3b),
                        fontWeight: FontWeight.w600),
                    textAlign: TextAlign.left,
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PromoCodeWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.only(left: 3, right: 3),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
            color: Color(0xFFfae3e2).withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 1,
            offset: Offset(0, 1),
          ),
        ]),
        child: TextFormField(
          decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
              ),
              enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFe6e1e1), width: 1.0),
                  borderRadius: BorderRadius.circular(7)),
              fillColor: Colors.white,
              hintText: 'Add Your Promo Code',
              filled: true,
              suffixIcon: IconButton(
                  icon: Icon(
                    Icons.local_offer,
                    color: Color(0xFFfd2c2c),
                  ),
                  onPressed: () {
                    debugPrint('222');
                  })),
        ),
      ),
    );
  }
}

class CartItem extends StatefulWidget {

  String productName;
  String productPrice;
  String productImage;
  String productCartQuantity;
  String productId;

  CartItem({
    Key? key,
    required this.productName,
    required this.productPrice,
    required this.productImage,
    required this.productCartQuantity,
    required this.productId,
  }) : super(key: key);

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
        productName: json['name'],
        productPrice: json['formated_price'],
        productImage: json['product']['images'][0]['url'].toString(),
        productCartQuantity: json['quantity'].toString(),
        productId: json['id'].toString()
    );
  }


  @override
  _CartItemState createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  var counterProvider;
  String smallSentence(String bigSentence){
    if(bigSentence.length > 15){
      return bigSentence.substring(0,15) + '...';
    }
    else{
      return bigSentence;
    }
  }

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

  @override
  Widget build(BuildContext context) {
    counterProvider = CountProvider.of(context);
    //print(counterProvider.counter.count);
    // print(counterProvider.counter.count);
    return Container(
      width: double.infinity,
      height: 130,
      decoration: BoxDecoration(boxShadow: [
        BoxShadow(
          color: Color(0xFFfae3e2).withOpacity(0.3),
          spreadRadius: 1,
          blurRadius: 1,
          offset: Offset(0, 1),
        ),
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
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 5, right: 5, top: 10, bottom: 10),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Container(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Center(
                        child: Image.network(
                          widget.productImage,
                          width: 110,
                          height: 100,
                        )),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                    Container(
                                child: Text(
                                  smallSentence(widget.productName),
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xFF3a3a3b),
                                      fontWeight: FontWeight.w400),
                                  textAlign: TextAlign.left,
                                ),
                  ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              child: Text(
                                widget.productPrice,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Color(0xFF3a3a3b),
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.left,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 40,
                        ),
                        InkWell(
                          onTap: () => removeItemFromCart(int.parse(widget.productId)),
                          child: Container(
                          alignment: Alignment.centerRight,
                          child: Image.asset(
                            "assets/images/menus/ic_delete.png",
                            width: 25,
                            height: 25,
                          ),
                        ),)
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 20),
                      alignment: Alignment.centerRight,
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            IconButton(
                              onPressed: () {if(counterProvider.counter.count>1)_decrementCounter();},
                              icon: Icon(Icons.remove),
                              color: Colors.black,
                              iconSize: 18,
                            ),
                            InkWell(
                              onTap: () => editCartItem(counterProvider.counter.count, widget.productId),
                              child: Container(
                                width: 100.0,
                                height: 35.0,
                                decoration: BoxDecoration(
                                  color: Color(0xFFfd2c2c),
                                  border: Border.all(color: Colors.white, width: 2.0),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Center(
                                  child: Text(
                                    'Quantity : ' + counterProvider.counter.count.toString(),
                                    style: new TextStyle(
                                        fontSize: 12.0,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w300),
                                  ),
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {_incrementCounter();},
                              icon: Icon(Icons.add),
                              color: Color(0xFFfd2c2c),
                              iconSize: 18,
                            ),
                          ],
                        ),
                      )
                    )
                    ],
                )
              ],
            ),
          )),
    );
  }
}

class CartIconWithBadge extends StatelessWidget {
  var counterProvider;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        IconButton(
            icon: Icon(
              Icons.business_center,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {print(total);}),
        counterProvider.counter.count != 0
            ? Positioned(
          right: 11,
          top: 11,
          child: Container(
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(6),
            ),
            constraints: BoxConstraints(
              minWidth: 14,
              minHeight: 14,
            ),
            child: Text(
              counterProvider.counter.count.toString(),
              style: TextStyle(
                color: Colors.red,
                fontSize: 8,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        )
            : Container()
      ],
    );
  }
}

class AddToCartMenu extends StatelessWidget {
  int productCounter;
  String id;

  AddToCartMenu(this.productCounter, this.id);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
            onPressed: () {if(productCounter>1)productCounter--;},
            icon: Icon(Icons.remove),
            color: Colors.black,
            iconSize: 18,
          ),
          InkWell(
            onTap: () => editCartItem(productCounter, id),
            child: Container(
              width: 100.0,
              height: 35.0,
              decoration: BoxDecoration(
                color: Color(0xFFfd2c2c),
                border: Border.all(color: Colors.white, width: 2.0),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: Center(
                child: Text(
                  'Quantity  :  $productCounter',
                  style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {productCounter++;},
            icon: Icon(Icons.add),
            color: Color(0xFFfd2c2c),
            iconSize: 18,
          ),
        ],
      ),
    );
  }
}

Future<http.Response> removeItemFromCart(int id) async {
  String ide = id.toString();
  Uri countryUrl = Uri.parse(removeUrl + ide + '?token=true');
  // Create storage
  final storage = new FlutterSecureStorage();
  // Read value
  String? token = await storage.read(key: 'jwt');
  //print(countryUrl);
  final response = await http.get(
    countryUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
  );
  // print(response.body);
  return response;
}

Future<http.Response> editCartItem(int quantity, String id) async {
  String number = quantity.toString();
  Uri countryUrl = Uri.parse(editCart + '?token=true');
  Map map = {
    "qty": {id: quantity},
  };
  // Create storage
  final storage = new FlutterSecureStorage();
  // Read value
  String? token = await storage.read(key: 'jwt');
  //print(countryUrl);
  final response = await http.put(
    countryUrl,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    },
    body: json.encode(map),
  );
  // print(response.body);
  return response;
}