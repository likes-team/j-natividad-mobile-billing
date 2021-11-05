import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    Key key,
    @required this.passwordController,
  }) : super(key: key);

  final TextEditingController passwordController;

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool passwordVisible;
  bool isDisposed = false;

  @override
  void initState() {
    passwordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Stack(
      children: <Widget>[
        
        Container(
          margin: EdgeInsets.only(top: 10.0),
          height: 50.0,
          width: MediaQuery.of(context).size.width - 100,
          child: TextFormField(
            controller: widget.passwordController,
            obscureText: !passwordVisible,
            decoration: new InputDecoration(
              filled: true,
              fillColor: Color(0xFFEFEFEF),
              hintText: "Password",
              contentPadding: const EdgeInsets.only(
                  top: 10.0, bottom: 10.0, left: 10.0, right: 20.0),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Color(0xFFEFEFEF))),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  borderSide: BorderSide(color: Color(0xFFEFEFEF))),
            ),
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            margin: EdgeInsets.only(top: 10.0, right: 5.0),
            width: 40.0,
            height: 45.0,
            child: IconButton(
              iconSize: 25,
              icon: Icon(
                passwordVisible ? Icons.visibility : Icons.visibility_off,
                size: 20,
              ),
              onPressed: () {
                if (!isDisposed) {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                }
              },
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
