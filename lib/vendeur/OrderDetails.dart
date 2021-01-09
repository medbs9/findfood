import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/constants.dart';
import 'package:find_food/models/Orders.dart';
import 'package:find_food/models/panier.dart';
import 'package:find_food/services/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OrderDetails extends StatefulWidget {
  static String id = 'OrderDetails';

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Store store = Store();

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
    String documentId = ModalRoute.of(context).settings.arguments;
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
                text: "Details",
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
              return StreamBuilder<QuerySnapshot>(
                  stream: _firestore
                      .collection('Orders')
                      .doc(documentId)
                      .collection("OrderDetails")
                      .where("productid", isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<CartItemModel> items = [];
                      for (var doc in snapshot.data.docs) {
                        var data = doc.data();
                        items.add(CartItemModel(
                          iName: data["iName"],
                          iQuantity: data["iQuantity"],
                          iImage: data["iImage"],
                          iPrice: data["iPrice"],
                          docid: doc.id,
                        ));
                      }

                      return Column(
                        children: <Widget>[
                          Expanded(
                            child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: CupertinoContextMenu(
                                      actions: <Widget>[
                                        CupertinoContextMenuAction(
                                          child:
                                              Center(child: Text('Supprimer')),
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection("Orders")
                                                .doc(documentId)
                                                .collection("OrderDetails")
                                                .doc(items[index].docid)
                                                .delete();
                                            Navigator.pop(context);
                                            for (var i
                                                in orders[index].iproductuser) {
                                              print(orders[index].iproductuser);
                                              print(user.uid);
                                              if (user.uid == i.toString()) {
                                                orders[index]
                                                    .iproductuser
                                                    .remove(i);
                                                List liste =
                                                    orders[index].iproductuser;

                                                _firestore
                                                    .collection('Orders')
                                                    .doc(documentId)
                                                    .update({
                                                  "iproductuser": liste,
                                                });
                                              }
                                            }
                                          },
                                        ),
                                      ],
                                      child: Container(
                                        height: 120,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.blue
                                                      .withOpacity(0.2),
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
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: <Widget>[
                                                  RichText(
                                                    text: TextSpan(children: [
                                                      TextSpan(
                                                          text: items[index]
                                                                  .iName +
                                                              "\n",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 20,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text:
                                                              "${items[index].iPrice}\D\T \n",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w300)),
                                                      TextSpan(
                                                          text: "Quantity:",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      TextSpan(
                                                          text:
                                                              "${items[index].iQuantity.toString()} \n\n",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      TextSpan(
                                                          text: "Prix total: ",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400)),
                                                      TextSpan(
                                                          text: ((double.parse(items[
                                                                          index]
                                                                      .iQuantity)) *
                                                                  (double.parse(
                                                                      items[index]
                                                                          .iPrice)))
                                                              .toString(),
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      TextSpan(
                                                          text: " DT ",
                                                          style: TextStyle(
                                                              color: Colors.red,
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ]),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ],
                      );
                    } else {
                      return Center(
                        child: Text('Loading Order Details'),
                      );
                    }
                  });
            }
          }),
    );
  }
}
