import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
                                onPressed: () {},
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
}
