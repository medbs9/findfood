import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/acheteur/Explore.dart';
import 'package:find_food/acheteur/details.dart';
import 'package:find_food/constants.dart';
import 'package:find_food/drawer/Contact.dart';
import 'package:find_food/drawer/aboutUs.dart';
import 'package:find_food/drawer/parametres.dart';
import 'package:find_food/drawer/profile.dart';
import 'package:find_food/models/Product.dart';
import 'package:find_food/models/panier.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/providers/CartItem.dart';
import 'package:find_food/providers/ModelHud.dart';
import 'package:find_food/screens/authentification/authentification.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Acheteur extends StatefulWidget {
  static String id = 'Acheteur';

  @override
  _AcheteurState createState() => _AcheteurState();
}

class _AcheteurState extends State<Acheteur> {
  int _tabBarIndex = 0;
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

  @override
  Widget build(BuildContext context) {
    List<CartItemModel> items = Provider.of<CartItem>(context).items;
    Utilisateur uuu = ModalRoute.of(context).settings.arguments;
    return Stack(
      children: <Widget>[
        DefaultTabController(
          length: 6,
          child: ModalProgressHUD(
            inAsyncCall: Provider.of<ModelHud>(context).isLoading,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                elevation: 0,
                leading: Builder(
                  builder: (context) => IconButton(
                    icon: Icon(
                      Icons.menu_rounded,
                      color: Colors.green[300],
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
                centerTitle: true,
                title: RichText(
                  text: TextSpan(
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        text: "Find",
                        style:
                            TextStyle(color: Colors.green[300], fontSize: 25),
                      ),
                      TextSpan(
                        text: "Food",
                        style: TextStyle(color: Colors.black, fontSize: 25),
                      ),
                    ],
                  ),
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(
                      Icons.explore,
                      color: Colors.green[300],
                      size: 30,
                    ),
                    onPressed: () async {
                      final modelhud =
                          Provider.of<ModelHud>(context, listen: false);
                      modelhud.changeisLoading(true);
                      await _getCurrentLocation();
                      modelhud.changeisLoading(false);
                      Navigator.pushNamed(context, Explore.id, arguments: aaa);
                      print(aaa);
                    },
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  indicatorColor: Colors.green[300],
                  onTap: (value) {
                    setState(() {
                      _tabBarIndex = value;
                    });
                  },
                  tabs: <Widget>[
                    Text(
                      'FastFoods',
                      style: TextStyle(
                        color: _tabBarIndex == 0 ? Colors.black : Colors.grey,
                        fontSize: _tabBarIndex == 0 ? 16 : null,
                      ),
                    ),
                    Text(
                      'Restaurants',
                      style: TextStyle(
                        color: _tabBarIndex == 1 ? Colors.black : Colors.grey,
                        fontSize: _tabBarIndex == 1 ? 16 : null,
                      ),
                    ),
                    Text(
                      'Epiceries',
                      style: TextStyle(
                        color: _tabBarIndex == 2 ? Colors.black : Colors.grey,
                        fontSize: _tabBarIndex == 2 ? 16 : null,
                      ),
                    ),
                    Text(
                      'Supermarches',
                      style: TextStyle(
                        color: _tabBarIndex == 3 ? Colors.black : Colors.grey,
                        fontSize: _tabBarIndex == 3 ? 16 : null,
                      ),
                    ),
                    Text(
                      'Boulangeries',
                      style: TextStyle(
                        color: _tabBarIndex == 4 ? Colors.black : Colors.grey,
                        fontSize: _tabBarIndex == 4 ? 16 : null,
                      ),
                    ),
                    Text(
                      'Patisseries',
                      style: TextStyle(
                        color: _tabBarIndex == 5 ? Colors.black : Colors.grey,
                        fontSize: _tabBarIndex == 5 ? 16 : null,
                      ),
                    ),
                  ],
                ),
              ),
              drawer: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: Colors.green[400],
                  primaryColorBrightness: Brightness.light,
                ),
                child: Drawer(
                  elevation: 10.0,
                  child: ListView(
                    children: <Widget>[
                      Container(
                        color: Colors.green[400],
                        child: UserAccountsDrawerHeader(
                          accountEmail: Text("${user?.email}"),
                          accountName: Text(uuu.uName),
                          currentAccountPicture: CircleAvatar(
                            maxRadius: 60,
                            backgroundColor:
                                Theme.of(context).platform == TargetPlatform.iOS
                                    ? Colors.blue
                                    : Colors.white,
                            child: uuu.uImage != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image(
                                      image: NetworkImage(uuu.uImage),
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Text(
                                    '${user?.email[0].toUpperCase()}',
                                    style: TextStyle(fontSize: 40.0),
                                  ),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text("Profil"),
                        trailing: Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Profile.id,
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.settings),
                        title: Text("Parametres"),
                        trailing: Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            Parametres.id,
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.info),
                        title: Text("À propos de nous"),
                        trailing: Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.of(context).push(new CupertinoPageRoute(
                              builder: (context) => AboutUs()));
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.phone),
                        title: Text("Contactez nous"),
                        trailing: Icon(Icons.arrow_right),
                        onTap: () {
                          Navigator.of(context).push(new CupertinoPageRoute(
                              builder: (context) => Contact()));
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 240),
                        child: ListTile(
                          leading: Icon(Icons.logout),
                          title: Text("Se déconnecter"),
                          trailing: Icon(Icons.arrow_right),
                          onTap: () {
                            Navigator.of(context).push(new CupertinoPageRoute(
                                builder: (context) => Authentification()));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              //bottomNavigationBar: BottomNavBar(),

              body: TabBarView(
                children: <Widget>[
                  FastFoods("Fast food"),
                  FastFoods("Restaurant"),
                  FastFoods("Epicerie"),
                  FastFoods("Super marché"),
                  FastFoods("boulangerie"),
                  FastFoods("Patisserie"),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget FastFoods(@required productname) {
    var size = MediaQuery.of(context).size;
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('Products')
          .where(kProductCategory, isEqualTo: productname)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
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
                //final datee = DateTime.parse(products[index].date);
                //final date = DateTime.now();
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 12.0),
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, DetailsScreen.id,
                                  arguments: products[index]);
                            },
                            child: Container(
                              height: 200,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(products[index].pLocation),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
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
                            /*CircleAvatar(
                              maxRadius: 20,
                              backgroundColor: Theme.of(context).platform ==
                                      TargetPlatform.iOS
                                  ? Colors.white
                                  : Colors.blue[400],
                              child: Text(
                                '${products[index].puser}',
                                style: TextStyle(fontSize: 40.0),
                              ),
                            ),*/
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              });
        } else {
          return Center(child: Text('Loading...'));
        }
      },
    );
  }
}
