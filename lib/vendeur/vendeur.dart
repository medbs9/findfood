import 'package:find_food/acheteur/config.dart';
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

  double xOffset = 0;
  double yOffset = 0;
  double scaleFactor = 1;

  bool isDrawerOpen = false;

  @override
  Widget build(BuildContext context) {
    Utilisateur uuu = ModalRoute.of(context).settings.arguments;
    screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.lightBlue[200],
            padding: EdgeInsets.only(top: 50, bottom: 70, left: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      maxRadius: 35,
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
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          uuu.uName,
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        Text("${user?.email}",
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold))
                      ],
                    )
                  ],
                ),
                Column(children: [
                  ListTile(
                    leading: Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Profil",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Profile.id,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.settings,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Parametres",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Parametres.id,
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.info,
                      color: Colors.black,
                    ),
                    title: Text(
                      "À propos de nous",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (context) => AboutUs()));
                    },
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.phone,
                      color: Colors.black,
                    ),
                    title: Text(
                      "Contactez nous",
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    onTap: () {
                      Navigator.of(context).push(new CupertinoPageRoute(
                          builder: (context) => Contact()));
                    },
                  ),
                ]),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, Authentification.id);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.logout,
                          color: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Se déconnecter',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
          AnimatedContainer(
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFactor)
              ..rotateY(isDrawerOpen ? -0.5 : 0),
            duration: Duration(milliseconds: 250),
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(isDrawerOpen ? 40 : 0.0)),
            child: Scaffold(
              extendBodyBehindAppBar: true,
              appBar: AppBar(
                elevation: 0,
                brightness: Brightness.light,
                title: Text(
                  "Espace vendeur",
                  style: TextStyle(color: Colors.black),
                ),
                backgroundColor: Colors.transparent,
                leading: isDrawerOpen
                    ? IconButton(
                        icon: Icon(
                          Icons.arrow_back_ios,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            xOffset = 0;
                            yOffset = 0;
                            scaleFactor = 1;
                            isDrawerOpen = false;
                          });
                        },
                      )
                    : IconButton(
                        icon: Icon(
                          Icons.menu,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            xOffset = 230;
                            yOffset = 150;
                            scaleFactor = 0.6;
                            isDrawerOpen = true;
                          });
                        }),
                centerTitle: true,
              ),
              /*drawer: Drawer(
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
              ),*/
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
                                Navigator.of(context).push(
                                    new CupertinoPageRoute(
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                    new CupertinoPageRoute(
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                                Navigator.of(context).push(
                                    new CupertinoPageRoute(
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
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
            ),
          ),
        ],
      ),
    );
  }
}
