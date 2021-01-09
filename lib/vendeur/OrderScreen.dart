//import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/constants.dart';
import 'package:find_food/models/Orders.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/services/adduser.dart';
import 'package:find_food/services/store.dart';
import 'package:find_food/vendeur/OrderDetails.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrdersScreen extends StatefulWidget {
  static String id = 'OrdersScreen';

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final Store _store = Store();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User user;

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
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.pop(context);
              }),
          centerTitle: true,
          title: RichText(
            text: TextSpan(
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
              children: [
                TextSpan(
                  text: "Les reservations",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('Orders')
                .where("iproductuser", arrayContains: user.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text('there is no orders'),
                );
              } else {
                List<Order> orders = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  orders.add(Order(
                    orderid: doc.id,
                    iImage: data[kProductLocation],
                    iName: data[kProductName],
                    iPrice: data["iPrice"],
                    dateTime: data["Date"].toString(),
                    iuser: data["userid"],
                    iproductuser: data["iproductuser"],
                    username: data["username"],
                  ));
                }
                return ListView.builder(
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(20),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, OrderDetails.id,
                            arguments: orders[index].orderid);
                      },
                      child: Card(
                          color: Colors.blue[300],
                          elevation: 4.0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            title: Container(
                              height: MediaQuery.of(context).size.height * .18,
                              color: Colors.blue[300],
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                        'Nom de l utilisateur : ${orders[index].username}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      ' Date : ${orders[index].dateTime}',
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            trailing: Column(
                              children: [
                                SizedBox(
                                  height: 32,
                                ),
                                Icon(
                                  Icons.keyboard_arrow_right,
                                  color: Colors.black,
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                  itemCount: orders.length,
                );
              }
            }));
  }
}
