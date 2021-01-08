import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Contact extends StatelessWidget {
  static String id = 'contact';

  Future<void> makeCall(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "nous ne pouvons pas lancer l'appel au $url";
    }
  }

  Future<void> makeSms(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "nous ne pouvons pas ecrire de sms au $url";
    }
  }

  Future<void> makeMail(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw "nous ne pouvons pas ecrire de mail au $url";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Colors.blue[600],
          Colors.blue[400],
          Colors.lightBlue[200]
        ])),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 80,
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "contactez nous",
                    style: TextStyle(color: Colors.black, fontSize: 46),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(50),
                        topRight: Radius.circular(50))),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 60,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(95, 225, 27, .3),
                                    blurRadius: 20,
                                    offset: Offset(0, 10))
                              ]),
                          child: Column(
                            children: <Widget>[],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Contact us with phone",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue[800]),
                          child: Row(children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.phone,
                                  color: Colors.white,
                                ),
                                onPressed: () => makeCall('tel:+21654511374')),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Phone",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Contact us with Message",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.blue),
                          child: Row(children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.message,
                                  color: Colors.white,
                                ),
                                onPressed: () =>
                                    makeSms('sms: +21654511374?body=Bonjour')),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Message",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text(
                          "Contact us with Email",
                          style: TextStyle(color: Colors.grey),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Colors.grey),
                          child: Row(children: <Widget>[
                            IconButton(
                                icon: Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                onPressed: () => makeMail(
                                    'mailto:medjpn12345@gmail.com?subject=like')),
                            SizedBox(
                              width: 30,
                            ),
                            Text(
                              "Email",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ]),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
