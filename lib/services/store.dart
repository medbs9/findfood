//import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/models/Orders.dart';
import 'package:find_food/models/Product.dart';
import 'package:find_food/constants.dart';
import 'package:find_food/models/panier.dart';

class Store {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  addProduct(Product product) {
    _firestore.collection('Products').add({
      kProductName: product.pName,
      kProductDescription: product.pDescription,
      kProductLocation: product.pLocation,
      kProductCategory: product.pCategory,
      kProductPrice: product.pPrice,
      kProductQuantity: product.pQuantity,
      kProductlat: product.plat,
      kProductlong: product.plong,
      kProductSoc: product.pSoc,
      kProductId: product.pId,
      kProductUser: product.puser,
      kProductCodep: product.pcodep,
      kProductAddress: product.padresse,
      kProductdate: product.date,
      kProducttime: product.time,
      ksearchindex: product.searchindex,
    });
  }

  addCartItem(CartItemModel item) {
    _firestore.collection('CartItems').add({
      "iId": item.iId,
      "iImage": item.iImage,
      "iName": item.iName,
      "iQuantity": item.iQuantity,
      "iPrice": item.iPrice,
      "iSoc": item.iSoc,
      "iuser": item.iuser,
      "iproductuser": item.iproductuser,
      "docid": item.docid,
    });
  }

  Stream<QuerySnapshot> loadProducts() {
    return _firestore.collection('Products').snapshots();
  }

  deleteProduct(documentId) {
    _firestore.collection('Products').doc(documentId).delete();
  }

  editProduct(data, documentId) {
    _firestore.collection('Products').doc(documentId).update(data);
  }

  storeOrders(data, List<CartItemModel> items) {
    var documentRef = _firestore.collection('Orders').doc();
    documentRef.set(data);
    for (var item in items) {
      documentRef.collection("OrderDetails").doc().set({
        "iName": item.iName,
        "iPrice": item.iPrice,
        "iQuantity": item.iQuantity,
        "iImage": item.iImage,
        "productid": item.iproductuser,
        //"Date": null,
        //"userid": null,
        //"iproductuser": null,
      });
    }
  }

  Stream<QuerySnapshot> loadOrders() {
    return _firestore.collection('Orders').snapshots();
  }

  Stream<QuerySnapshot> loadOrderDetails(documentId) {
    return _firestore
        .collection('Orders')
        .doc(documentId)
        .collection("OrderDetails")
        .snapshots();
  }
}
