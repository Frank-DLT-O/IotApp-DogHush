import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:DogHush/home_page.dart';
import 'package:DogHush/login/login_page.dart';
 
void main() async{
  //Inicializando Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bienvenido a DogHush App',
      home: LoginPage(),//  HomePage(),
    );
  }
}