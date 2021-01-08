import 'package:flutter/material.dart';

class CustomTexteField extends StatelessWidget {
  final String hint;
  final Function onClick;
  String _errorMessage(String str) {
    switch (hint) {
      case 'Enter your email':
        return 'Email is empty';
      case 'Enter your username':
        return 'Name is empty';
      case 'Enter your password':
        return 'password is emppty';
    }
  }

  CustomTexteField({@required this.onClick, @required this.hint});
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: TextFormField(
          // ignore: non_constant_identifier_names
          validator: (value) {
            if (value.isEmpty) {
              return _errorMessage(hint);
              // ignore: missing_return
            }
          },
          obscureText: hint == 'Enter your password' ? true : false,
          onSaved: onClick,
          decoration: InputDecoration(
            hintText: hint,
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
        ));
  }
}
