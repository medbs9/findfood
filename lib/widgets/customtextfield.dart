import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hint;
  final IconData icon;
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

  CustomTextField(
      {@required this.onClick, @required this.icon, @required this.hint});
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
            prefixIcon: Icon(icon),
            hintText: hint,
            filled: true,
            fillColor: Colors.blue[200],
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.blue[400],
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.blue[400],
                )),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide(
                  color: Colors.blue[400],
                )),
          ),
        ));
  }
}
