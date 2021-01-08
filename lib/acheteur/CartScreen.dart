import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/acheteur/acheteur.dart';
import 'package:find_food/acheteur/homepage.dart';
import 'package:find_food/models/Product.dart';
import 'package:find_food/models/panier.dart';
import 'package:find_food/providers/CartItem.dart';
import 'package:find_food/services/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';

class CartScreen extends StatefulWidget {
  static String id = "CartScreen";

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _store = Store();
  User user;
  //String name;
  //String q;
  List<String> list = [];
  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() {
    user = _auth.currentUser;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<CartItemModel> items = Provider.of<CartItem>(context).items;
    List<Product> products = Provider.of<CartItem>(context).products;
    final double screenHeight = MediaQuery.of(context).size.height;
    final double screenWidth = MediaQuery.of(context).size.width;
    //final double appBarHeight = AppBar().preferredSize.height;
    //final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        /*leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),*/
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Votre panier",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            if (items[index].iuser != user.uid) {
              Provider.of<CartItem>(context, listen: false)
                  .removefromcart(items[index]);
            }

            if ((items.isEmpty == false)) {
              list.add(items[index].iproductuser);
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.blue.withOpacity(0.2),
                            offset: Offset(3, 2),
                            blurRadius: 30)
                      ]),
                  child: Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        ),
                        child: Image.network(
                          items[index].iImage,
                          height: 120,
                          width: 140,
                          fit: BoxFit.fill,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            RichText(
                              text: TextSpan(children: [
                                TextSpan(
                                    text: items[index].iName + "\n",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                TextSpan(
                                    text: "${items[index].iPrice}\D\T \n\n",
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w300)),
                                TextSpan(
                                    text: "Quantity: ",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                                TextSpan(
                                    text: items[index].iQuantity.toString(),
                                    style: TextStyle(
                                        color: Colors.blue,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w400)),
                              ]),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  Alert(
                                      context: context,
                                      title:
                                          "Voulez vous vraiment supprimer cet article?",
                                      buttons: [
                                        DialogButton(
                                          onPressed: () {
                                            products[index].pQuantity +=
                                                int.parse(
                                                    items[index].iQuantity);
                                            _store.editProduct(
                                                ({
                                                  kProductQuantity:
                                                      products[index].pQuantity,
                                                }),
                                                products[index].pId);
                                            Provider.of<CartItem>(context,
                                                    listen: false)
                                                .removefromcart(items[index]);
                                            Provider.of<CartItem>(context,
                                                    listen: false)
                                                .removefromproducts(
                                                    products[index]);
                                            Navigator.pop(context);
                                          },
                                          child: Text(
                                            "Confirmer",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20),
                                          ),
                                        )
                                      ]).show();
                                })
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            } else {
              return Container(
                child: Center(
                  child: Text(
                    'Votre panier est vide',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              );
            }
          }),
      bottomNavigationBar: Builder(
        builder: (context) => ButtonTheme(
          minWidth: screenWidth,
          height: screenHeight * .08,
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    topLeft: Radius.circular(20))),
            onPressed: () {
              if (items.isEmpty) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return Dialog(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(20.0)), //this right here
                        child: Container(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      'Votre panier est vide',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
              if (items.isEmpty == false) {
                try {
                  _store.storeOrders({
                    "iproductuser": list[0],
                    "userid": user.uid,
                    "Date": DateFormat('yyyy-MM-dd – kk:mm')
                        .format(DateTime.now())
                        .toString()
                  }, items);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    content: Text("Ordered successfully"),
                  ));
                  items.clear();
                  products.clear();
                } catch (ex) {
                  print(ex.message);
                }
              }
            },
            child: Text('Réserver'.toUpperCase()),
            color: Colors.blue,
          ),
        ),
      ),
    );
  }
}
