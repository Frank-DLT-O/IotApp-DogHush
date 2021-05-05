import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

//Para mandar el archivo wav
import 'dart:convert';
import 'dart:typed_data';
// ignore: avoid_web_libraries_in_flutter
//import 'dart:html';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_parser/http_parser.dart';



class RecordListView extends StatefulWidget {
  final List<String> records;
  final String mascota;
  const RecordListView({
    Key key,
    this.records,
    this.mascota,
  }) : super(key: key);

  @override
  _RecordListViewState createState() => _RecordListViewState();
}

class _RecordListViewState extends State<RecordListView> {
  int _totalDuration;
  int _currentDuration;
  double _completedPercentage = 0.0;
  bool _isPlaying = false;
  int _selectedIndex = -1;
  int i = 2;
  //InputElement uploadInput = FileUploadInputElement();
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: new BoxDecoration(
          gradient: new LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black,
              Colors.black87,
              Colors.lightGreenAccent[400]
            ],
          ),
        ),
        child: ListView.builder(
          itemCount: widget.records.length,
          shrinkWrap: true,
          reverse: true,
          itemBuilder: (BuildContext context, i) {
            if (widget.records.length - i >= 3) {
              return Container(
                decoration: new BoxDecoration(
                  border: Border.all(
                    color: Colors.greenAccent,
                    width: 5,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ExpansionTile(
                  title: Text(
                    'Grabación para ${widget.mascota}: ${widget.records.length - i - 2}',
                    style: TextStyle(color: Colors.white, fontSize: 12.5),
                  ),
                  subtitle: Text(_getDateFromFilePatah(
                      filePath: widget.records.elementAt(i))),
                  onExpansionChanged: ((newState) {
                    if (newState) {
                      setState(() {
                        _selectedIndex = i;
                      });
                    }
                  }),
                  children: [
                    Container(
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LinearProgressIndicator(
                            minHeight: 5,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.greenAccent),
                            value:
                                _selectedIndex == i ? _completedPercentage : 0,
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                  child: MaterialButton(
                                onPressed: () {
                                  sendFile(File(widget.records.elementAt(i)), widget.mascota);
                                },
                                child: Text(
                                  "Send!",
                                  style: TextStyle(color: Colors.white),
                                ),
                              )),
                              Expanded(
                                child: IconButton(
                                  icon: _selectedIndex == i
                                      ? _isPlaying
                                          ? Icon(Icons.pause,
                                              color: Colors.greenAccent)
                                          : Icon(Icons.play_arrow,
                                              color: Colors.white)
                                      : Icon(Icons.play_arrow,
                                          color: Colors.greenAccent),
                                  onPressed: () => _onPlay(
                                      filePath: widget.records.elementAt(i),
                                      index: i),
                                ),
                              ),
                              
                              Expanded(
                                  child: IconButton(
                                onPressed: () {
                                  setState(() {
                                    deleteAudio(File(widget.records.elementAt(i)));
                                    widget.records.removeAt(i);
                                  });
                                  
                                },
                                icon: Icon(Icons.delete,
                                          color: Colors.white),
                              )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }

  Future<void> _onPlay({@required String filePath, @required int index}) async {
    AudioPlayer audioPlayer = AudioPlayer();
    print(filePath.substring(45)); //Filename
    if (!_isPlaying) {
      audioPlayer.play(filePath, isLocal: true);
      setState(() {
        _selectedIndex = index;
        _completedPercentage = 0.0;
        _isPlaying = true;
      });

      audioPlayer.onPlayerCompletion.listen((_) {
        setState(() {
          _isPlaying = false;
          _completedPercentage = 0.0;
        });
      });
      audioPlayer.onDurationChanged.listen((duration) {
        setState(() {
          _totalDuration = duration.inMicroseconds;
        });
      });

      audioPlayer.onAudioPositionChanged.listen((duration) {
        setState(() {
          _currentDuration = duration.inMicroseconds;
          _completedPercentage =
              _currentDuration.toDouble() / _totalDuration.toDouble();
        });
      });
    }
  }

  String _getDateFromFilePatah({@required String filePath}) {
    String filetime = filePath.substring(
        filePath.lastIndexOf('/') + 1, filePath.lastIndexOf('.'));

    DateTime recordedDate =
        DateTime.fromMillisecondsSinceEpoch(int.parse(filetime));
    int year = recordedDate.year;
    int month = recordedDate.month;
    int day = recordedDate.day;
    int hour = recordedDate.hour;
    int min = recordedDate.minute;

    return ('$year-$month-$day $hour\:$min');
    /*return ('21/04/21');*/
  }


  Future<void> deleteAudio(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    // Error in getting access to the file.
  }
}

 /*void uploadFile() async {
  uploadInput.draggable = true;
  uploadInput.click();
  uploadInput.onChange.listen((e) {
    // read file content as dataURL
    final files = uploadInput.files;
    final reader = new FileReader();

    if (files.length == 1) {
      final file = files[0];

      reader.onLoad.listen((e) {
        sendFile(reader.result);
      });

      reader.readAsDataUrl(file);
    }
  });
}*/

sendFile(File file, String name) async {
  /*var url = Uri.parse("http://localhost:3000/upload");
  var request = new http.MultipartRequest("POST", url);
  Uint8List _bytesData =
      Base64Decoder().convert(file.toString().split(",").last);
  List<int> _selectedFile = _bytesData;

  request.files.add(http.MultipartFile.fromBytes('file', _selectedFile,
      contentType: new MediaType('application', 'octet-stream'),
      filename: "sound.wav"));

  request.send().then((response) {
    print("test");
    print(response.statusCode);
    if (response.statusCode == 200) print("Uploaded!");
  });*/

String  x = await getFunction();
   print(x);
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.grey[300],
        title: Text('Sonido Enviado, Woof!',
                                  style: TextStyle(color: Colors.green)),
        content: Container(
          child: Text('Dohush: Nuevo mensaje para '  + name,
                                  style: TextStyle(color: Colors.green)),
        ),
        actions: <Widget>[
          TextButton(
            child: Text('Ok',
                                  style: TextStyle(color: Colors.green)),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
      },
  );
  
}

Future<String> getFunction() async {
  
    Response response = await get('https://n6n3fk1q23.execute-api.us-east-1.amazonaws.com/dev/movil');
    String _productsApiList = "";
    print("API Response Code: ${response.statusCode}");

     if (response.statusCode == 200) {
      _productsApiList = response.body;
      //print(data);
      //return _productsApiList;
      
      
    }

    return _productsApiList;
  }


}
