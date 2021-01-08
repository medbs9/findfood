import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/acheteur/acheteur.dart';
import 'package:find_food/acheteur/homepage.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/services/adduser.dart';
import 'package:find_food/vendeur/vendeur.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
//import 'package:geocoder/geocoder.dart';
//import 'package:geolocator/geolocator.dart';

import 'constants.dart';

class Homepage extends StatefulWidget {
  static String id = 'Homepage';

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User user;

  Utilisateur uuu;

  @override
  void initState() {
    super.initState();
    initUser();
  }

  initUser() {
    user = _auth.currentUser;
    setState(() {});
  }

  final _store = AddUser();

  /*String _locationMessage = "";
  String _lat, _long, aaa, _adresse;

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(position);
    _lat = position.latitude.toString();
    _long = position.longitude.toString();

    _adresse = "${first.addressLine}";

    print(_adresse);
    List aa = _adresse.split(",");
    aaa = aa[-2];

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.loaduser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Utilisateur> utilisatuers = [];
              for (var doc in snapshot.data.docs) {
                var data = doc.data();
                utilisatuers.add(Utilisateur(
                    uName: data[kname],
                    uemail: data[kmail],
                    uPhone: data[kphone],
                    uuid: doc.id,
                    uImage: data[kuImage],
                    uId: data[kuid]));
              }
              for (Utilisateur i in utilisatuers) {
                if (i.uId == user.uid) {
                  uuu = i;
                }
              }
              return Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        colors: [
                      Colors.blue[400],
                      Colors.blue[600],
                      Colors.lightBlue[800]
                    ])),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Image.asset(
                      'assets/logoo2.png',
                      height: 300,
                      width: 250,
                    ),
                    SizedBox(
                      height: 110,
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 80.0, right: 80.0),
                      child: OutlineButton(
                        onPressed: () {
                          Navigator.pushNamed(context, Vendeur.id,
                              arguments: uuu);
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Vendre',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                            Icon(Icons.arrow_forward_ios_sharp)
                          ],
                        ),
                        borderSide: BorderSide(
                          color: Colors.black, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: 1.5, //width of the border
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      '--------  ou  --------',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontStyle: FontStyle.italic),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: EdgeInsets.only(left: 80.0, right: 80.0),
                      child: RaisedButton(
                        elevation: 0,
                        onPressed: () {
                          Navigator.pushNamed(context, Home.id, arguments: uuu);
                        },
                        color: Colors.blue[300],
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text('Acheter',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 20)),
                            Icon(Icons.arrow_forward_ios_sharp)
                          ],
                        ),
                        textColor: Colors.black,
                        //shape: new RoundedRectangleBorder(
                        //  borderRadius: new BorderRadius.circular(30.0),
                        //),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Center(child: Text('Loading...'));
            }
          }),
    );
  }
}
