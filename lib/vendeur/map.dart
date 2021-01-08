import 'package:find_food/constants.dart';
import 'package:find_food/services/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/models/Product.dart';

class Map extends StatefulWidget {
  static String id = 'Map';
  _Map createState() => new _Map();
}

class _Map extends State<Map> {
  final _store = Store();
  List<Product> products = [];

  //final _startPointController = TextEditingController();
  //Set<Marker> markers = Set();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: StreamBuilder<QuerySnapshot>(
            stream: _store.loadProducts(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<Product> products = [];
                for (var doc in snapshot.data.docs) {
                  var data = doc.data();
                  products.add(Product(
                    pPrice: data[kProductPrice],
                    pName: data[kProductName],
                    pDescription: data[kProductDescription],
                    pLocation: data[kProductLocation],
                    pCategory: data[kProductCategory],
                    pQuantity: data[kProductQuantity],
                    plat: data[kProductlat],
                    plong: data[kProductlong],
                  ));
                }
                print(products);
                return ListView.builder(
                    itemCount: snapshot.data.size.compareTo(0),
                    itemBuilder: (context, index) => Container(
                          height: 680,
                          alignment: Alignment.center,
                          child: FlutterMap(
                            options: new MapOptions(
                              center: LatLng(double.parse(products[index].plat),
                                  double.parse(products[index].plong)),
                              zoom: 13.0,
                            ),
                            layers: [
                              new TileLayerOptions(
                                urlTemplate:
                                    "https://api.mapbox.com/styles/v1/medbs/ckikn8qzd13vh17qvcprg4rkh/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoibWVkYnMiLCJhIjoiY2tpa216eHNiMGEwcTMxcDl0bGg2djBxeSJ9.oNlVzRtnvcF-lyIKJDPjxg",
                                additionalOptions: {
                                  'accessToken':
                                      'pk.eyJ1IjoibWVkYnMiLCJhIjoiY2tpa216eHNiMGEwcTMxcDl0bGg2djBxeSJ9.oNlVzRtnvcF-lyIKJDPjxg',
                                  'id': 'mapbox.mapbox-streets-v8',
                                },
                              ),
                              new MarkerLayerOptions(
                                markers: [
                                  new Marker(
                                    width: 80.0,
                                    height: 80.0,
                                    point: LatLng(
                                        double.parse(products[index].plat),
                                        double.parse(products[index].plong)),
                                    builder: (ctx) => new Container(
                                      child: IconButton(
                                        icon: Icon(Icons.location_on),
                                        color: Colors.blue,
                                        iconSize: 45.0,
                                        onPressed: () {
                                          print('Marker tapped');
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ));
              } else {
                return Center(child: Text('Loading...'));
              }
            }));
  }
}
