import 'package:find_food/Homepage.dart';
import 'package:find_food/providers/ModelHud.dart';
import 'package:find_food/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:find_food/screens/authentification/signup.dart';
import 'package:find_food/services/auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class Authentification extends StatelessWidget {
  static String id = 'Authentification';
  String email, password;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();
  final auth = Auth();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: ModalProgressHUD(
          inAsyncCall: Provider.of<ModelHud>(context).isLoading,
          child: Form(
            key: _globalKey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 50),
                  child: Container(
                    height: MediaQuery.of(context).size.height * .2,
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        Image(
                          image: AssetImage('assets/logoo.png'),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 80,
                ),
                CustomTextField(
                    onClick: (value) {
                      email = value;
                    },
                    icon: Icons.email,
                    hint: 'Enter your email'),
                SizedBox(
                  height: 20,
                ),
                CustomTextField(
                    onClick: (value) {
                      password = value;
                    },
                    icon: Icons.lock,
                    hint: 'Enter your password'),
                SizedBox(
                  height: 50,
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 120),
                    child: Builder(
                        builder: (context) => FlatButton(
                              onPressed: () async {
                                final modelhud = Provider.of<ModelHud>(context,
                                    listen: false);
                                modelhud.changeisLoading(true);
                                if (_globalKey.currentState.validate()) {
                                  _globalKey.currentState.save();
                                  try {
                                    final authresult = await auth.signIn(
                                        email.trim(), password.trim());
                                    modelhud.changeisLoading(false);
                                    Navigator.pushNamed(context, Homepage.id);
                                    Fluttertoast.showToast(
                                        msg: 'operation succeeded');
                                  } catch (e) {
                                    modelhud.changeisLoading(false);
                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text(e.message)));
                                  }
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20)),
                              color: Colors.blue[400],
                              child: Text(
                                'login',
                                style: TextStyle(color: Colors.black),
                              ),
                            ))),
                SizedBox(
                  height: 70,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      'don\'t have an account?',
                      style: TextStyle(color: Colors.black, fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(context, Signup.id);
                      },
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
