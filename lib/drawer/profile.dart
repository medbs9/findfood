import 'dart:io';
import 'package:path/path.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:find_food/models/user.dart';
import 'package:find_food/services/adduser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import '../constants.dart';

class Profile extends StatefulWidget {
  static String id = 'profile';
  final String currentUserId;
  Profile({this.currentUserId});
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
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

  final _store = AddUser();
  editUser(data, documentId) {
    _firestore.collection("Users").doc(documentId).update(data);
  }

  String _name, _email, _phone;
  Utilisateur uuu;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  File _imageFile;
  String imageURL;
  String _imageLocation;

  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(
        source: ImageSource.gallery, maxWidth: 200, maxHeight: 200);

    setState(() {
      _imageFile = File(pickedFile.path);
    });
  }

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile.path);
    Reference firebaseStorageRef =
        FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() async {
      try {
        imageURL = (await firebaseStorageRef.getDownloadURL()).toString();
      } catch (onError) {
        print("Error");
      }
    });
    taskSnapshot.ref.getDownloadURL().then((value) {
      print(value);
      _imageLocation = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Profil',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Form(
        key: _globalKey,
        child: StreamBuilder<QuerySnapshot>(
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
                return Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          colors: [
                        Colors.blue[600],
                        Colors.blue[400],
                        Colors.lightBlue[200]
                      ])),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 60,
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 130.0, bottom: 50.0),
                        child: Column(
                          children: <Widget>[
                            Stack(children: <Widget>[
                              SizedBox(
                                width: 350,
                              ),
                              CircleAvatar(
                                maxRadius: 60,
                                backgroundColor: Theme.of(context).platform ==
                                        TargetPlatform.iOS
                                    ? Colors.blue
                                    : Colors.white,
                                //backgroundImage: NetworkImage(uuu.uImage),
                                child: _imageFile != null
                                    ? ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(100),
                                        child: Image.file(
                                          _imageFile,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Text(
                                        '${user?.email[0].toUpperCase()}',
                                        style: TextStyle(fontSize: 40.0),
                                      ),
                              ),
                              Padding(
                                //right: 0,
                                //bottom: 0,
                                padding: EdgeInsets.only(top: 80, left: 90),
                                child: CircleAvatar(
                                  backgroundColor: Colors.blue,
                                  child: IconButton(
                                    icon: Icon(Icons.edit),
                                    color: Colors.white,
                                    onPressed: pickImage,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                            ]),
                            Row(
                              children: [
                                uploadImageButton(context),
                                SizedBox(
                                  width: 100,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(50),
                                  topRight: Radius.circular(50))),
                          child: ListView(
                            children: <Widget>[
                              SizedBox(
                                height: 70,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextFormField(
                                    initialValue: info[1],
                                    onSaved: (value) {
                                      _email = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.email),
                                      //hintText: "your email",
                                      filled: true,
                                      fillColor: Colors.blue[200],
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextFormField(
                                    initialValue: info[0],
                                    onSaved: (value) {
                                      _name = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.perm_identity),
                                      filled: true,
                                      fillColor: Colors.blue[200],
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                    ),
                                  )),
                              SizedBox(
                                height: 20,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: TextFormField(
                                    initialValue: info[2],
                                    onSaved: (value) {
                                      _phone = value;
                                    },
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(Icons.phone),
                                      filled: true,
                                      fillColor: Colors.blue[200],
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                            color: Colors.blue[400],
                                          )),
                                    ),
                                  )),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 85.0),
                                margin: const EdgeInsets.only(
                                    top: 10,
                                    left: 10.0,
                                    right: 10.0,
                                    bottom: 10.0),
                                width: 5,
                                child: RaisedButton(
                                  color: Colors.blue[400],
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20)),
                                  onPressed: () {
                                    print(_name);
                                    print(_email);
                                    print(_phone);
                                    print(uuu.uuid);
                                    if (_globalKey.currentState.validate()) {
                                      _globalKey.currentState.save();

                                      editUser({
                                        kname: _name,
                                        kmail: _email,
                                        kphone: _phone,
                                        kuImage: _imageLocation,
                                      }, uuu.uuid);
                                      user.updateEmail(_email);
                                      Fluttertoast.showToast(
                                          msg: 'operation succeeded');
                                    }
                                  },
                                  child: Text('Sauvgarder'),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                );
              } else {
                return Center(child: Text('Loading...'));
              }
            }),
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            margin: const EdgeInsets.only(
                top: 10, left: 10.0, right: 10.0, bottom: 10.0),
            height: 30,
            decoration: BoxDecoration(
                color: Colors.lightBlue[200],
                borderRadius: BorderRadius.circular(20.0)),
            child: FlatButton(
              onPressed: () {
                uploadImageToFirebase(context);
                Fluttertoast.showToast(msg: 'operation succeeded');
              },
              child: Text(
                "Confirmer",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
