import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/acheteur/Orderdetails2.dart';
import 'package:find_food/acheteur/acheteur.dart';
import 'package:find_food/acheteur/homepage.dart';
import 'package:find_food/constants.dart';
import 'package:find_food/models/Orders.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/services/adduser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Commandes extends StatefulWidget {
  static String id = 'Commandes';

  @override
  _CommandesState createState() => _CommandesState();
}

class _CommandesState extends State<Commandes> {
  final _store2 = AddUser();

  Map infoo = {};

  List info = [];

  String aba;

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
                  text: "Vos commandes",
                  style: TextStyle(color: Colors.black, fontSize: 25),
                ),
              ],
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: _store2.loaduser(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Utilisateur> utilisatuers = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  utilisatuers.add(Utilisateur(
                      uName: data[kname],
                      uemail: data[kmail],
                      uPhone: data[kphone],
                      uImage: data[kuImage],
                      uuid: doc.id,
                      uId: data[kuid]));
                }
                for (Utilisateur i in utilisatuers) {
                  infoo[i.uuid] = i.uName;
                }
                return StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('Orders')
                        .where("userid", isEqualTo: user.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            'there is no orders',
                            style: (TextStyle(color: Colors.black)),
                          ),
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
                          ));
                        }

                        for (Order i in orders) {
                          info.add(i.iuser);
                        }
                        for (var key in infoo.keys) {
                          if (info.contains(key)) {
                            aba = infoo[key];
                          }
                        }
                        print(aba);
                        return ListView.builder(
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(20),
                            child: CupertinoContextMenu(
                              actions: <Widget>[
                                CupertinoContextMenuAction(
                                  child: Center(child: Text('Supprimer')),
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection("Orders")
                                        .doc(orders[index].orderid)
                                        .delete();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, OrderDetails2.id,
                                      arguments: orders[index].orderid);
                                },
                                child: Card(
                                    color: Colors.blue[300],
                                    elevation: 4.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: ListTile(
                                      title: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                .16,
                                        color: Colors.blue[300],
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              /*Text(
                                                  'Id user : ${orders[index].iuser}',
                                                  style: TextStyle(
                                                      fontSize: 18,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              SizedBox(
                                                height: 10,
                                              ),*/
                                              Text(
                                                ' Date : ${orders[index].dateTime}',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                          ),
                          itemCount: orders.length,
                        );
                      }
                    });
              } else {
                return Center(child: Text('Loading...'));
              }
            }));
  }
}

class MyPopupMenuItem<T> extends PopupMenuItem<T> {
  final Widget child;
  final Function onClick;
  MyPopupMenuItem({@required this.child, @required this.onClick})
      : super(child: child);
  @override
  PopupMenuItemState<T, PopupMenuItem<T>> createState() {
    return MyPopupMenuItemState();
  }
}

class MyPopupMenuItemState<T, PopMenuItem>
    extends PopupMenuItemState<T, MyPopupMenuItem<T>> {
  @override
  void handleTap() {
    widget.onClick();
  }
}
