import 'package:find_food/constants.dart';
import 'package:find_food/models/Product.dart';
import 'package:find_food/models/panier.dart';
import 'package:find_food/providers/CartItem.dart';
import 'package:find_food/services/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Confirmer extends StatefulWidget {
  static String id = 'Confirmer';

  @override
  _ConfirmerState createState() => _ConfirmerState();
}

class _ConfirmerState extends State<Confirmer> {
  int quantity = 0;
  final _key = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _store = Store();
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

  @override
  Widget build(BuildContext context) {
    Product product = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      key: _key,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(
            icon: Icon(
              Icons.close,
              color: Colors.black,
            ),
            onPressed: () {
              Navigator.pop(context);
            }),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          CircleAvatar(
            radius: 120,
            backgroundImage: NetworkImage(product.pLocation),
          ),
          SizedBox(
            height: 15,
          ),
          Text("${product.pName}",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          Text("${product.pPrice}\D\T",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w400)),
          SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.remove,
                      size: 36,
                    ),
                    onPressed: () {
                      if (quantity != 0) {
                        setState(() {
                          quantity -= 1;
                        });
                      }
                    }),
              ),
              Builder(
                builder: (context) => GestureDetector(
                  onTap: () {
                    CartItem cartItem =
                        Provider.of<CartItem>(context, listen: false);
                    bool exist = false;
                    var productsincart = cartItem.products;
                    for (var productincart in productsincart) {
                      if (productincart.pName == product.pName) {
                        exist = true;
                      }
                    }
                    if (exist) {
                      Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Element existe deja dans le panier")));
                    } else {
                      if (quantity == 0) {
                        Scaffold.of(context)
                            .showSnackBar(SnackBar(content: Text("Sold Out")));
                      } else {
                        cartItem.addProduct(product);

                        product.pQuantity = product.pQuantity - quantity;
                        CartItemModel cartItemModel = CartItemModel(
                          iImage: product.pLocation,
                          iProductid: product.pId,
                          iPrice: product.pPrice,
                          iName: product.pName,
                          iSoc: product.pSoc,
                          iQuantity: quantity.toString(),
                          iuser: user.uid,
                          iproductuser: product.puser,
                        );
                        _store.addCartItem(cartItemModel);

                        cartItem.addToCart(cartItemModel);
                        _store.editProduct(
                            ({
                              kProductQuantity: product.pQuantity,
                            }),
                            product.pId);

                        Scaffold.of(context).showSnackBar(
                            SnackBar(content: Text("Ajouter au panier")));
                      }
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20)),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                      child: Text("Ajouter $quantity à votre panier",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w300,
                              color: Colors.white)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: IconButton(
                    icon: Icon(
                      Icons.add,
                      size: 36,
                      color: Colors.red,
                    ),
                    onPressed: () {
                      if (quantity < product.pQuantity) {
                        setState(() {
                          quantity += 1;
                        });
                      }
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
