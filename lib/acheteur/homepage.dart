import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/acheteur/CartScreen.dart';
import 'package:find_food/acheteur/Commandes.dart';
import 'package:find_food/acheteur/Notifs.dart';
import 'package:find_food/acheteur/acheteur.dart';
import 'package:find_food/acheteur/recherche.dart';
import 'package:find_food/models/panier.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/providers/CartItem.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  static String id = 'home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _bottomBarIndex = 0;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
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

  String _locationMessage = "";
  String _lat, _long, aaa, _adresse;

  Future _getCurrentLocation() async {
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
    aaa = aa[aa.length - 2];

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
    });
  }

  List<Widget> list = [
    Acheteur(),
    Commandes(),
    //Notif(),
    Rechercher(),
    CartScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    List<CartItemModel> items = Provider.of<CartItem>(context).items;
    Utilisateur uuu = ModalRoute.of(context).settings.arguments;
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 6,
          child: Scaffold(
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              unselectedItemColor: Colors.grey,
              currentIndex: _bottomBarIndex,
              fixedColor: Colors.green[400],
              onTap: (value) async {
                setState(() {
                  _bottomBarIndex = value;
                });
              },
              items: [
                BottomNavigationBarItem(
                    label: 'Accueil', icon: Icon(Icons.home)),
                BottomNavigationBarItem(
                    label: 'Commandes', icon: Icon(Icons.shopping_basket)),
                //BottomNavigationBarItem(
                // label: 'Notifs', icon: Icon(Icons.notifications)),
                BottomNavigationBarItem(
                    label: 'Rechercher', icon: Icon(Icons.search)),
                BottomNavigationBarItem(
                    label: 'Panier', icon: Icon(Icons.shopping_bag)),
              ],
            ),
            body: Center(
              child: list.elementAt(_bottomBarIndex),
            ),
          ),
        ),
      ],
    );
  }
}
