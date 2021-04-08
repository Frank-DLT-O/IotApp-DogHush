import 'package:DogHush/login/bloc/login_bloc.dart';
import 'package:DogHush/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:DogHush/auth/user_auth_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginBloc _loginBloc;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 24),
            Image(
              image: AssetImage('images/Doghush.png'),
              height: 200,
            ),
            SizedBox(height: 24),
            MaterialButton(
              onPressed: () {},
              child: Text("Grabar Nuevo Sonido"),
              color: Colors.lightGreenAccent[400],
            ),
            SizedBox(height: 24),
            MaterialButton(
              onPressed: () {
                BlocProvider.of<LoginBloc>(context).add(LogoutEvent()); 
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            LoginPage())); //MainMenu
              },
              child: Text("Log Off"),
              color: Colors.lightGreenAccent[400],
            )
          ],
        ),
      ),
    );
  }
}
