import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/acheteur/acheteur.dart';
import 'package:find_food/acheteur/homepage.dart';
import 'package:find_food/constants.dart';
import 'package:find_food/models/Product.dart';
import 'package:flutter/material.dart';
import 'details.dart';

class Rechercher extends StatefulWidget {
  static String id = 'Rechercher';
  @override
  RechercherState createState() => RechercherState();
}

class RechercherState extends State<Rechercher> {
  TextEditingController textEditingController = TextEditingController();
  String searchString;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            onPressed: () {
              //Navigator.pop(context);
            }),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            controller: textEditingController,
            onChanged: (val) {
              setState(() {
                searchString = val.toLowerCase();
              });
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 25.0),
              hintText: 'Rechercher par le nom du produit',
            ),
          ),
        ),
      ),
      backgroundColor: Colors.white,
      body: Column(
        children: <Widget>[
          SizedBox(height: 10.0),
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
            stream: (searchString == null || searchString.trim() == '')
                ? FirebaseFirestore.instance
                    .collection('Products')
                    .where(ksearchindex, arrayContains: 'null')
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('Products')
                    .where(ksearchindex, arrayContains: searchString)
                    .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('we have an error');
              }
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return SizedBox(
                    child: Center(
                      child: Text("Loading"),
                    ),
                  );
                case ConnectionState.none:
                  return Text('oops no data');
                default:
                  List<Product> products = [];
                  for (var doc in snapshot.data.docs) {
                    var data = doc.data();
                    products.add(Product(
                        puser: data[kProductUser],
                        pSoc: data[kProductSoc],
                        plat: data[kProductlat],
                        plong: data[kProductlong],
                        date: data[kProductdate],
                        time: data[kProducttime],
                        pId: doc.id,
                        pPrice: data[kProductPrice],
                        pName: data[kProductName],
                        pDescription: data[kProductDescription],
                        pLocation: data[kProductLocation],
                        pCategory: data[kProductCategory],
                        padresse: data[kProductAddress],
                        pQuantity: data[kProductQuantity]));
                  }
                  print(products);

                  return ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return Opacity(
                          opacity: 1,
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 12.0),
                            padding: EdgeInsets.symmetric(horizontal: 25.0),
                            child: Column(
                              children: <Widget>[
                                Stack(
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, DetailsScreen.id,
                                            arguments: products[index]);
                                      },
                                      child: Container(
                                        height: 200,
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                              image: NetworkImage(
                                                  products[index].pLocation),
                                              fit: BoxFit.cover,
                                            ),
                                            borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(10.0),
                                              topRight: Radius.circular(10.0),
                                            )),
                                      ),
                                    ),
                                  ],
                                ),
                                Container(
                                  padding: EdgeInsets.all(25.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(10.0),
                                          bottomRight: Radius.circular(10.0)),
                                      boxShadow: [
                                        BoxShadow(
                                            blurRadius: 2.0,
                                            spreadRadius: 1.0,
                                            color: Colors.grey)
                                      ]),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            products[index].pName,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                          Text(
                                            "${products[index].pPrice}\D\T",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        products[index].pSoc,
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.black),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(
                                            products[index].date,
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                          Text(
                                            "${products[index].time}",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      });
              }
            },
          ))
        ],
      ),
    );
  }
}
