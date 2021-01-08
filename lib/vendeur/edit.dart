import 'package:find_food/constants.dart';
import 'package:find_food/models/Product.dart';
import 'package:find_food/services/store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'dart:io';
import 'package:path/path.dart';

class Edit extends StatefulWidget {
  static String id = 'edit';

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<Edit> {
  String _name, _price, _description;
  int _quantity;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _store = Store();

  final categoriesselected = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
        centerTitle: true,
        title: RichText(
          text: TextSpan(
            style: Theme.of(context)
                .textTheme
                .headline6
                .copyWith(fontWeight: FontWeight.bold),
            children: [
              TextSpan(
                text: "Modifier",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ],
          ),
        ),
      ),
      //resizeToAvoidBottomPadding: false,
      body: Form(
        key: _globalKey,
        child: ListView(
          children: <Widget>[
            SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: 150.0,
                height: 350.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(product.pLocation)),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  color: Colors.black,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  initialValue: product.pName,
                  onSaved: (value) {
                    _name = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Nom du produit",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  initialValue: product.pPrice,
                  onSaved: (value) {
                    _price = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Prix du produit",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  initialValue: product.pQuantity.toString(),
                  onSaved: (value) {
                    _quantity = int.parse(value);
                  },
                  decoration: InputDecoration(
                    hintText: "quantité du produit",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: TextFormField(
                  initialValue: product.pDescription,
                  onSaved: (value) {
                    _description = value;
                  },
                  decoration: InputDecoration(
                    hintText: "Description du produit",
                    filled: true,
                    fillColor: Colors.white,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.black,
                        )),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 85.0),
              margin: const EdgeInsets.only(
                  top: 10, left: 10.0, right: 10.0, bottom: 10.0),
              width: 5,
              child: RaisedButton(
                color: Colors.blue[400],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                onPressed: () {
                  if (_globalKey.currentState.validate()) {
                    _globalKey.currentState.save();

                    _store.editProduct(
                        ({
                          kProductDescription: _description,
                          kProductName: _name,
                          kProductPrice: _price,
                          kProductQuantity: _quantity,
                        }),
                        product.pId);

                    Fluttertoast.showToast(msg: 'operation succeeded');
                  }
                },
                child: Text('Modifier le produit'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
