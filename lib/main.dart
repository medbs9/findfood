import 'package:find_food/Homepage.dart';
import 'package:find_food/acheteur/CartScreen.dart';
import 'package:find_food/acheteur/Commandes.dart';
import 'package:find_food/acheteur/Confirmer.dart';
import 'package:find_food/acheteur/Explore.dart';
import 'package:find_food/acheteur/Orderdetails2.dart';
import 'package:find_food/acheteur/acheteur.dart';
import 'package:find_food/acheteur/details.dart';
import 'package:find_food/acheteur/homepage.dart';
import 'package:find_food/acheteur/recherche.dart';
import 'package:find_food/drawer/Contact.dart';
import 'package:find_food/drawer/Help.dart';
import 'package:find_food/drawer/Settings.dart';
import 'package:find_food/drawer/aboutUs.dart';
import 'package:find_food/drawer/parametres.dart';
import 'package:find_food/drawer/profile.dart';
import 'package:find_food/providers/CartItem.dart';
import 'package:find_food/providers/ModelHud.dart';
import 'package:find_food/screens/authentification/authentification.dart';
import 'package:find_food/screens/authentification/signup.dart';
import 'package:find_food/splashscreen.dart';
import 'package:find_food/vendeur/Ajouter.dart';
import 'package:find_food/vendeur/Modifier.dart';
import 'package:find_food/vendeur/OrderDetails.dart';
import 'package:find_food/vendeur/OrderScreen.dart';
import 'package:find_food/vendeur/edit.dart';
import 'package:find_food/vendeur/supprimer.dart';
import 'package:find_food/vendeur/vendeur.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:find_food/vendeur/map.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<CartItem>(create: (context) => CartItem()),
        ChangeNotifierProvider<ModelHud>(
          create: (context) => ModelHud(),
        ),
      ],
      child: MaterialApp(
          initialRoute: Splashscreen.id,
          debugShowCheckedModeBanner: false,
          routes: {
            Splashscreen.id: (context) => Splashscreen(),
            Authentification.id: (context) => Authentification(),
            Signup.id: (context) => Signup(),
            Homepage.id: (context) => Homepage(),
            Vendeur.id: (context) => Vendeur(),
            Ajouter.id: (context) => Ajouter(),
            Modifier.id: (context) => Modifier(),
            Supprimer.id: (context) => Supprimer(),
            Map.id: (context) => Map(),
            Contact.id: (context) => Contact(),
            Profile.id: (context) => Profile(),
            AboutUs.id: (context) => AboutUs(),
            Edit.id: (context) => Edit(),
            DetailsScreen.id: (context) => DetailsScreen(),
            Settings.id: (context) => Settings(),
            CartScreen.id: (context) => CartScreen(),
            Acheteur.id: (context) => Acheteur(),
            Confirmer.id: (context) => Confirmer(),
            Parametres.id: (context) => Parametres(),
            OrdersScreen.id: (context) => OrdersScreen(),
            Explore.id: (context) => Explore(),
            OrderDetails.id: (context) => OrderDetails(),
            Rechercher.id: (context) => Rechercher(),
            Commandes.id: (context) => Commandes(),
            Home.id: (context) => Home(),
            OrderDetails2.id: (context) => OrderDetails2(),
            Help.id: (context) => Help(),
          }),
    );
  }
}
