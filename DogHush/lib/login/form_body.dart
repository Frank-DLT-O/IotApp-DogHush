import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'dart:ui';

class FormBody extends StatelessWidget {
  // cambiar a un solo value changed que reciba enum de login
  final ValueChanged<bool> onEmailLoginTap;
  final ValueChanged<bool> onGoogleLoginTap;
  final ValueChanged<bool> onFacebookLoginTap;

  FormBody({
    Key key,
    @required this.onEmailLoginTap,
    @required this.onGoogleLoginTap,
    @required this.onFacebookLoginTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // logo
        
        SizedBox(height: 60),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 32),
          child: Text(
            "Bienvenido a DogHush App",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.5),
                  offset: Offset(1, 2),
                  blurRadius: 1.0,
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.black,
                endIndent: 0,
                indent: 8,
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                "Acceso con correo de Google.",
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: Colors.black,
                endIndent: 8,
                indent: 0,
              ),
            ),
          ],
        ),
        SizedBox(height: 14),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 32),
          child: Row(
            children: [
              Expanded(
                child: GoogleSignInButton(
                  onPressed: () => onGoogleLoginTap(true),
                  text: "Iniciar con Google",
                  textStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                  borderRadius: 18.0,
                  darkMode: false,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
      ],
    );
  }
}
