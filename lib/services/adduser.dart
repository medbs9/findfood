import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/constants.dart';

class AddUser {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  adduser(Utilisateur user) {
    _firestore.collection('Users').add({
      kuid: user.uId,
      kname: user.uName,
      kpwd: user.uPwd,
      kmail: user.uemail,
      kphone: user.uPhone,
      kuuid: user.uuid,
      kuImage: user.uImage,
    });
  }

  Stream<QuerySnapshot> loaduser() {
    return _firestore.collection('Users').snapshots();
  }
}
