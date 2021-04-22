import 'dart:io';

import 'package:DogHush/login/bloc/login_bloc.dart';
import 'package:DogHush/login/login_page.dart';
import 'package:flutter/material.dart';
import 'package:DogHush/auth/user_auth_provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:DogHush/recordlist.dart';
import 'package:DogHush/viewrecord.dart';
import 'package:path_provider/path_provider.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  LoginBloc _loginBloc;
  final _textController = TextEditingController();
  Directory appDirectory;
  Stream<FileSystemEntity> fileStream;
  List<String> records;
  String mascota = "";
  @override
  void initState() {
    super.initState();
    records = [];
    getApplicationDocumentsDirectory().then((value) {
      appDirectory = value;
      appDirectory.list().listen((onData) {
        records.add(onData.path);
      }).onDone(() {
        records = records.reversed.toList();
        setState(() {});
      });
    });
  }

  @override
  void dispose() {
    fileStream = null;
    appDirectory = null;
    records = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
                  child: Column(
            children: [
              SizedBox(height: 24),
              Image(
                image: AssetImage('images/Doghush.png'),
                height: 200,
              ),
              SizedBox(height: 24),
              Container(
                height: 40,
                width: 205,
                decoration: new BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.lightGreenAccent[400]
        ),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: _textController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Nombre de la Mascota",
                    hintStyle: TextStyle(color: Colors.black,fontSize: 10, fontWeight: FontWeight.w900),
                    prefix: Icon(Icons.border_color),
                  ),
                ),
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  //Mostrar Dialogo
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: RecorderView(
                              onSaved: _onRecordComplete,
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Grabar Nuevo Sonido"),
                color: Colors.lightGreenAccent[400],
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  //Mostrar Dialogo
                  if(_textController.text != ""){
                    mascota = _textController.text;
                  } else {
                    mascota = "Nuestro amigo";
                  }
                  
                  showDialog(
                    context: context,
                    builder: (_) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 2,
                            child: Container(
                              child: RecordListView(
                                records: records,
                                mascota: mascota,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text("Ver Sonido Grabado"),
                color: Colors.lightGreenAccent[400],
              ),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () {
                  BlocProvider.of<LoginBloc>(context).add(LogoutEvent());
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              LoginPage())); //MainMenu
                },
                child: Text("Log Out"),
                color: Colors.lightGreenAccent[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  _onRecordComplete() {
    records.clear();
    appDirectory.list().listen((onData) {
      records.add(onData.path);
    }).onDone(() {
      //records = records.reversed.toList();
      setState(() {
        records.sort();
      });
    });
  }
}
