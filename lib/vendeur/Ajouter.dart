import 'package:find_food/models/Product.dart';
import 'package:find_food/providers/ModelHud.dart';
import 'package:find_food/services/store.dart';
import 'package:find_food/widgets/customtextefield.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocoder/geocoder.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong/latlong.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Ajouter extends StatefulWidget {
  static String id = 'Ajouter';

  @override
  _AjouterState createState() => _AjouterState();
}

class _AjouterState extends State<Ajouter> {
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

  File _imageFile;
  String imageURL;

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

  var categories = [
    "Fast food",
    "Patisserie",
    "Epicerie",
    "Super marché",
    "Restaurant",
    "boulangerie"
  ];

  String selectcategory = '';
  String dropdownValue = "Fast Food";

  String _name,
      _price,
      _description,
      _category,
      _imageLocation,
      _lat,
      _long,
      _societe,
      aaa,
      _adresse;
  int _quantity;

  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  final _store = Store();

  final categoriesselected = TextEditingController();
  TextEditingController textEditingController = TextEditingController();

  String _locationMessage = "";

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    final coordinates = new Coordinates(position.latitude, position.longitude);
    var addresses =
        await Geocoder.local.findAddressesFromCoordinates(coordinates);
    var first = addresses.first;
    print(position);
    _lat = position.latitude.toString();
    _long = position.longitude.toString();

    _adresse = "${first.addressLine}";

    print(_adresse);
    List aa = _adresse.split(",");
    aaa = aa[aa.length - 2];

    setState(() {
      _locationMessage = "${position.latitude}, ${position.longitude}";
    });
  }

  String _setTime, _setDate;

  String _hour, _minute, _time;

  String dateTime;

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime(2015),
        lastDate: DateTime(2101));
    if (picked != null)
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat.yMd().format(selectedDate);
      });
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        _hour = selectedTime.hour.toString();
        _minute = selectedTime.minute.toString();
        _time = _hour + ' : ' + _minute;
        _timeController.text = _time;
      });
  }

  @override
  Widget build(BuildContext context) {
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
                text: "Ajouter",
                style: TextStyle(color: Colors.black, fontSize: 25),
              ),
            ],
          ),
        ),
      ),
      resizeToAvoidBottomPadding: false,
      body: ModalProgressHUD(
        inAsyncCall: Provider.of<ModelHud>(context).isLoading,
        child: Form(
          key: _globalKey,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 10,
              ),
              /*CustomTexteField(
                hint: 'Nom de la marque',
                onClick: (val) {
                  _societe = val;
                },
              ),*/
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: TextFormField(
                    // ignore: non_constant_identifier_names

                    decoration: InputDecoration(
                      hintText: "Marque",
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          )),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          )),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Colors.black,
                          )),
                    ),
                    controller: textEditingController,
                    onChanged: (val) {
                      setState(() {
                        _societe = val;
                      });
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              CustomTexteField(
                hint: 'Nom de produit',
                onClick: (value) {
                  _name = value;
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTexteField(
                onClick: (value) {
                  _price = value;
                },
                hint: 'Prix du produit',
              ),
              SizedBox(
                height: 10,
              ),
              CustomTexteField(
                hint: 'quantité de produit',
                onClick: (value) {
                  _quantity = int.parse(value);
                },
              ),
              SizedBox(
                height: 10,
              ),
              CustomTexteField(
                onClick: (value) {
                  _description = value;
                },
                hint: 'Description du produit',
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: DropdownButtonFormField(
                    value: null,
                    icon: Icon(Icons.arrow_downward),
                    decoration: InputDecoration(
                        labelText: "Select Category",
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10))),
                    items: categories.map((String value) {
                      return new DropdownMenuItem<String>(
                        value: value,
                        child: new Text(value),
                      );
                    }).toList(),
                    onChanged: (String newvalue) {
                      setState(() {
                        dropdownValue = newvalue;
                        _category = newvalue;
                      });
                    },
                  )),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('Ajouter une localisation:',
                        style: TextStyle(color: Colors.black, fontSize: 15)),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(30.0),
                      child: FlatButton(
                          child: Icon(
                            Icons.location_on_sharp,
                            size: 40,
                          ),
                          onPressed: () async {
                            final modelhud =
                                Provider.of<ModelHud>(context, listen: false);
                            modelhud.changeisLoading(true);
                            uploadImageToFirebase(context);
                            await _getCurrentLocation();
                            modelhud.changeisLoading(false);
                            Fluttertoast.showToast(msg: 'operation succeeded');
                          }),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Ajouter une date:',
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        SizedBox(
                          width: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: FlatButton(
                              child: Icon(
                                Icons.calendar_today,
                                size: 30,
                              ),
                              onPressed: () {
                                _selectDate(context);
                              }),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        //_selectDate(context);
                      },
                      child: Container(
                        width: 130,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _dateController,
                          onSaved: (String val) {
                            _setDate = val;
                          },
                          decoration: InputDecoration(
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(30, 0, 30, 0),
                decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Text('Ajouter le temps:',
                            style:
                                TextStyle(color: Colors.black, fontSize: 15)),
                        SizedBox(
                          width: 10,
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: FlatButton(
                              child: Icon(
                                Icons.timer,
                                size: 30,
                              ),
                              onPressed: () {
                                _selectTime(context);
                              }),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        //_selectDate(context);
                      },
                      child: Container(
                        width: 130,
                        height: 30,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: Colors.white),
                        child: TextFormField(
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                          enabled: false,
                          keyboardType: TextInputType.text,
                          controller: _timeController,
                          onSaved: (String val) {
                            _setTime = val;
                          },
                          decoration: InputDecoration(
                              disabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide.none),
                              contentPadding: EdgeInsets.only(top: 0.0)),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 4,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Ajouter une image:',
                      style: TextStyle(color: Colors.black, fontSize: 15)),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: _imageFile != null
                        ? Image.file(_imageFile)
                        : FlatButton(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 50,
                            ),
                            onPressed: pickImage,
                          ),
                  ),
                  uploadImageButton(context),
                ],
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
                      _globalKey.currentState.reset();
                      List<String> azer = uploadData(_name);
                      print(azer);
                      _store.addProduct(Product(
                          pName: _name,
                          pPrice: _price,
                          pDescription: _description,
                          pLocation: _imageLocation,
                          pCategory: _category,
                          pQuantity: _quantity,
                          puser: user.uid,
                          pSoc: _societe.toString(),
                          padresse: _adresse,
                          pcodep: aaa,
                          searchindex: azer,
                          plat: _lat,
                          date: _setDate,
                          time: _setTime,
                          plong: _long));

                      Fluttertoast.showToast(msg: 'operation succeeded');
                    }
                  },
                  child: Text('Ajouter le produit'),
                ),
              )
            ],
          ),
        ),
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
                final modelhud = Provider.of<ModelHud>(context, listen: false);
                modelhud.changeisLoading(true);
                uploadImageToFirebase(context);
                modelhud.changeisLoading(false);
                Fluttertoast.showToast(msg: 'operation succeeded');
              },
              child: Text(
                "Télécharger l'image",
                style: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  uploadData(String name) {
    List<String> splitList = name.split(' ');
    List<String> indexList = [];

    for (int i = 0; i < splitList.length; i++) {
      for (int j = 0; j < splitList[i].length + i; j++) {
        indexList.add(splitList[i].substring(0, j).toLowerCase());
      }
    }
    print(indexList);
    return indexList;
  }
}
