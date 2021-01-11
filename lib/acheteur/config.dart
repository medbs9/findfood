import 'package:flutter/material.dart';

Color primaryGreen = Color(0xff416d6d);
List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey[300], blurRadius: 30, offset: Offset(0, 10))
];

List<Map> drawerItems = [
  {
    'icon': Icons.account_circle,
    'title': 'Profil',
  },
  {'icon': Icons.settings, 'title': 'Parametre'},
  {'icon': Icons.info, 'title': 'A propos de nous'},
  {'icon': Icons.phone, 'title': 'Contactez nous'},
];
