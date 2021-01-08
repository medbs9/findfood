import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/drawer/profile.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/services/adduser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import '../constants.dart';

class Parametres extends StatefulWidget {
  static String id = 'Parametres';

  @override
  _ParametresState createState() => _ParametresState();
}

class _ParametresState extends State<Parametres> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  String password;
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

  final _store = AddUser();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  editUser(data, documentId) {
    _firestore.collection("Users").doc(documentId).update(data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        centerTitle: true,
        title: Text(
          'Paramètres',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _store.loaduser(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Utilisateur> utilisatuers = [];
              for (var doc in snapshot.data.docs) {
                var data = doc.data();
                utilisatuers.add(Utilisateur(
                    uName: data[kname],
                    uemail: data[kmail],
                    uPhone: data[kphone],
                    uImage: data[kuImage],
                    uuid: doc.id,
                    uId: data[kuid]));
              }
              List info = [];
              for (Utilisateur i in utilisatuers) {
                if (i.uId == user.uid) {
                  info.add(i.uName);
                  info.add(i.uemail);
                  info.add(i.uPhone);
                  uuu = i;
                }
              }
              return Stack(
                children: <Widget>[
                  SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        Card(
                          elevation: 8.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: Colors.blue,
                          child: ListTile(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                Profile.id,
                              );
                            },
                            title: Text(
                              "${uuu.uName}",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            leading: CircleAvatar(
                              maxRadius: 25,
                              backgroundColor: Theme.of(context).platform ==
                                      TargetPlatform.iOS
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
                            trailing: Icon(
                              Icons.keyboard_arrow_right,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 80,
                        ),
                        Card(
                          elevation: 4.0,
                          margin: const EdgeInsets.fromLTRB(32, 10, 32, 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: ListTile(
                            leading: Icon(
                              Icons.lock_outline,
                              color: Colors.blue,
                            ),
                            title: Text("Changer le mot de passe"),
                            trailing: Icon(Icons.keyboard_arrow_right),
                            onTap: () {
                              print(uuu.uName);
                              print(uuu.uPwd);
                              _onAlertWithCustomContentPressed(context);
                              print(uuu.uPwd);
                            },
                          ),
                        ),
                        const SizedBox(
                          height: 130,
                        ),
                        Text(
                          "Parametres de notification",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[400],
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        SwitchListTile(
                          dense: true,
                          activeColor: Colors.blue[400],
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            "Recevoir des notifications",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          value: true,
                          onChanged: (val) {},
                        ),
                        SwitchListTile(
                          dense: true,
                          activeColor: Colors.blue[400],
                          contentPadding: const EdgeInsets.all(0),
                          title: Text(
                            "newsletters et offres spéciales",
                            style: TextStyle(
                              fontSize: 15,
                              color: Colors.black,
                            ),
                          ),
                          value: true,
                          onChanged: (val) {},
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: Text('Loading...'));
            }
          }),
    );
  }

  _onAlertWithCustomContentPressed(context) {
    Alert(
        context: context,
        title: "Changer le mot de passe",
        content: Form(
          key: _globalKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Ancien mot de passe',
                ),
              ),
              TextFormField(
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nouveau mot de passe',
                ),
              ),
              TextFormField(
                obscureText: true,
                onSaved: (value) {
                  password = value;
                },
                decoration: InputDecoration(
                  labelText: 'Confirmer mot de passe',
                ),
              ),
            ],
          ),
        ),
        buttons: [
          DialogButton(
            onPressed: () async {
              if (_globalKey.currentState.validate()) {
                _globalKey.currentState.save();
                try {
                  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
                  User currentUser = firebaseAuth.currentUser;
                  currentUser.updatePassword(password).then((_) {
                    editUser({
                      kpwd: password,
                    }, uuu.uuid);
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            "votre mot de passe à été changé avec succès")));
                  }).catchError((err) {
                    Scaffold.of(context)
                        .showSnackBar(SnackBar(content: Text("Réessayez SVP")));
                  });
                  Navigator.pop(context);
                } catch (e) {
                  Scaffold.of(context)
                      .showSnackBar(SnackBar(content: Text(e.message)));
                }
              } else {
                return Center(child: Text('Loading...'));
              }
            },
            child: Text(
              "Confirmer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          )
        ]).show();
  }
}