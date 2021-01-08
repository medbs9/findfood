import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoder/geocoder.dart';
import 'package:latlong/latlong.dart';

class Carte extends StatelessWidget {
  static String id = 'carte';

  final String long;
  final String lat;
  final String addresse;

  Carte({@required this.long, @required this.lat, @required this.addresse});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Container(
          height: 680,
          alignment: Alignment.center,
          child: FlutterMap(
            options: new MapOptions(
              center: LatLng(double.parse(lat), double.parse(long)),
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
                    point: LatLng(double.parse(lat), double.parse(long)),
                    builder: (ctx) => new Container(
                      child: IconButton(
                        icon: Icon(Icons.location_on),
                        color: Colors.blue,
                        iconSize: 45.0,
                        onPressed: () {
                          showModalBottomSheet(
                              context: context,
                              builder: (builder) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    color: Colors.white,
                                  ),
                                  height: 70,
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "L\'adresse est:",
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(addresse,
                                          style: TextStyle(fontSize: 15)),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
