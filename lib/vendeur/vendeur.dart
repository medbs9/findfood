import 'package:find_food/drawer/Contact.dart';
import 'package:find_food/drawer/aboutUs.dart';
import 'package:find_food/drawer/parametres.dart';
import 'package:find_food/drawer/profile.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/screens/authentification/authentification.dart';
import 'package:find_food/vendeur/Ajouter.dart';
import 'package:find_food/vendeur/Modifier.dart';
import 'package:find_food/vendeur/OrderScreen.dart';
import 'package:find_food/vendeur/supprimer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class Vendeur extends StatefulWidget {
  static String id = 'Vendeur';
  @override
  VendeurPageState createState() => VendeurPageState();
}

class VendeurPageState extends State<Vendeur> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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

  Size screenSize;

  @override
  Widget build(BuildContext context) {
    Utilisateur uuu = ModalRoute.of(context).settings.arguments;
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        title: Text(
          "Espace vendeur",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(
              Icons.menu_rounded,
              color: Colors.black,
            ),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        elevation: 10.0,
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
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
            ListTile(
              leading: Icon(Icons.person),
              title: Text("Profil"),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).push(new CupertinoPageRoute(
                    builder: (context) => Profile(
                          currentUserId: user.uid,
                        )));
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
                Navigator.of(context).push(
                    new CupertinoPageRoute(builder: (context) => AboutUs()));
              },
            ),
            ListTile(
              leading: Icon(Icons.phone),
              title: Text("Contactez nous"),
              trailing: Icon(Icons.arrow_right),
              onTap: () {
                Navigator.of(context).push(
                    new CupertinoPageRoute(builder: (context) => Contact()));
              },
            ),
            Padding(
              padding: EdgeInsets.only(top: 260),
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
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(color: Colors.white),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(8.0),
            child: new Column(
              children: <Widget>[
                new SizedBox(
                  height: 20.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => Ajouter()));
                      },
                      child: new Container(
                        //maxRadius: 85.0,
                        height: 170,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.add,
                              size: 40,
                            ),
                            new SizedBox(
                              height: 20.0,
                            ),
                            new Text(
                              "Ajouter un produit",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => Modifier()));
                      },
                      child: new Container(
                        //maxRadius: 85.0,
                        height: 170,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[200],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.update,
                              size: 40,
                            ),
                            new SizedBox(
                              height: 20.0,
                            ),
                            new Text(
                              "Modifier un produit",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                new SizedBox(
                  height: 30.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(new CupertinoPageRoute(
                            builder: (context) => Supprimer()));
                      },
                      child: new Container(
                        height: 170,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[200],
                            borderRadius: BorderRadius.circular(20)),
                        //maxRadius: 85.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.delete,
                              size: 40,
                            ),
                            new SizedBox(
                              height: 20.0,
                            ),
                            new Text(
                              "Supprimer un produit",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, OrdersScreen.id,
                            arguments: uuu);
                      },
                      child: new Container(
                        height: 170,
                        width: 160,
                        decoration: BoxDecoration(
                            color: Colors.lightBlue[200],
                            borderRadius: BorderRadius.circular(20)),
                        //maxRadius: 85.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            new Icon(
                              Icons.person,
                              size: 40,
                            ),
                            new SizedBox(
                              height: 20.0,
                            ),
                            new Text(
                              "Voir les reservations",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
