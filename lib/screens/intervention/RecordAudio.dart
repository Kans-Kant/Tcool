import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_audio_recorder/flutter_audio_recorder.dart';
import 'dart:io' as io;

import 'package:path_provider/path_provider.dart';
import 'package:tcool_flutter/controllers/InterventionController.dart';
import 'package:tcool_flutter/localization/LocalizationConstants.dart';
import 'package:tcool_flutter/resources/utils.dart';
import 'package:tcool_flutter/screens/themes/light_color.dart';

class RecordAudio extends StatefulWidget {
  String audioFileName;
  RecordAudio({Key key, this.audioFileName}) : super(key: key);
  @override
  _RecordAudioState createState() => _RecordAudioState();
}

class _RecordAudioState extends State<RecordAudio> {
  FlutterAudioRecorder _recorder;
  Recording _recording;
  String _alert;
  Timer _t;
  String audio_name;
  File audioFile;

  //handle error of audio dispose
  bool _disposed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(getTranslated(context, 'enr_voc'), style: TextStyle(fontWeight: FontWeight.bold, fontFamily: "mulish"))),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: _showRecording(),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    Timer(Duration(seconds: 1), () {
      if (!_disposed)
        setState(() {
          //_t = _t.add(Duration(seconds: -1));
          //_t = _t.tick();
        });
    });
    super.initState();
    Future.microtask(() => _prepare());
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }

//------------------- audio recorder -------------------
  void _opt() async {
    switch (_recording.status) {
      case RecordingStatus.Initialized:
        await _startRecording();
        break;
      case RecordingStatus.Recording:
        await _stopRecording();
        break;
      case RecordingStatus.Stopped:
        await _prepare();
        break;
      default:
        break;
    }
  }

  Future _init() async {
    try {
      if (await FlutterAudioRecorder.hasPermissions) {
        String customPath = 'intervention_audio_';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = await getExternalStorageDirectory();
        }
        audio_name = customPath + DateTime.now().millisecondsSinceEpoch.toString();
        customPath = appDocDirectory.path + '/' + audio_name;
        print(customPath);

        _recorder = FlutterAudioRecorder(customPath, audioFormat: AudioFormat.WAV, sampleRate: 44100);
        await _recorder.initialized;
      }
    } catch (e) {
      print(e);
    }
  }

  Future _prepare() async {
    var hasPermission = await FlutterAudioRecorder.hasPermissions;
    if (hasPermission) {
      await _init();
      var result = await _recorder.current();
      if (mounted) {
        setState(() {
          _recording = result;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          _alert = "Permission Required.";
        });
      }
    }
  }

  void start() async {
    if (_recording.status == RecordingStatus.Initialized) {
      await _startRecording();
    } else if (_recording.status == RecordingStatus.Paused) {
      await _resumeRecording();
    }
  }

  Widget _startButton() => InkWell(
        onTap: () => {start()},
        child: Container(
          height: 50,
          width: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: LightColor.blueLinkedin, //Color(0xff006a71),
          ),
          child: Center(
              child: Icon(
            Icons.play_arrow,
            color: Colors.white,
          )),
        ),
      );

  Future _startRecording() async {
    await _recorder.start();
    var current = await _recorder.current(); //channel: 2);
    if (mounted) {
      setState(() {
        _recording = current;
      });
    }

    _t = Timer.periodic(Duration(milliseconds: 10), (Timer t) async {
      var current = await _recorder.current();
      if (mounted) {
        setState(() {
          _recording = current;
          _t = t;
        });
      }
    });
  }

  void _play() {
    AudioPlayer player = AudioPlayer();
    player.play(_recording.path, isLocal: true);
  }

  void stop() async {
    if (_recording.status == RecordingStatus.Recording) {
      await _stopRecording();
    }
  }

  Future _stopRecording() async {
    var result = await _recorder.stop();
    _t.cancel();
    if (mounted) {
      setState(() {
        _recording = result;
      });
    }
    // _prepare();
  }

  Widget _stopButton() => InkWell(
        onTap: () => {stop()},
        child: Container(
          height: 50,
          width: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: LightColor.blueLinkedin, //Color(0xff006a71),
          ),
          child: Center(
              child: Icon(
            Icons.stop,
            color: Colors.white,
          )),
        ),
      );

  Widget _pauseButton() => InkWell(
        onTap: () => {pause()},
        child: Container(
          height: 50,
          width: 50,
          padding: EdgeInsets.symmetric(horizontal: 10),
          decoration: new BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
            color: LightColor.blueLinkedin, //Color(0xff006a71),
          ),
          child: Center(
              child: Icon(
            Icons.pause_circle_filled,
            color: Colors.white,
          )),
        ),
      );

  void pause() async {
    if (_recording.status == RecordingStatus.Recording) {
      await _pauseRecording();
    }
  }

  void resume() async {
    if (_recording.status == RecordingStatus.Paused) {
      await _resumeRecording();
    }
  }

  Future _resumeRecording() async {
    var result = await _recorder.resume();
    if (mounted) {
      setState(() {
        _recording = result;
      });
    }
  }

  Future _pauseRecording() async {
    var result = await _recorder.pause();
    if (mounted) {
      setState(() {
        _recording = result;
      });
    }
  }

  Widget _playerIcon(RecordingStatus status) {
    switch (status) {
      case RecordingStatus.Initialized:
        return Icon(Icons.fiber_manual_record);
      case RecordingStatus.Recording:
        return Icon(Icons.stop);
      case RecordingStatus.Stopped:
        return Icon(Icons.replay);
      default:
        return Icon(Icons.do_not_disturb_on);
    }
  }

  Widget _showRecording() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Text('${_recording?.path ?? "-"}'),
          //SizedBox(height: 5),
          Text(getTranslated(context, 'duree'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(
            height: 5,
          ),
          Text(
            format(_recording?.duration),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 5,
          ),
          //Text('Status'),
          //Text('${_recording?.status ?? "-"}'),
          SizedBox(
            height: 20,
          ),
          RaisedButton(child: Text(getTranslated(context, 'jouer')), disabledColor: Colors.grey.withOpacity(0.5), disabledTextColor: Colors.white, onPressed: _recording?.status == RecordingStatus.Stopped ? _play : null),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[_startButton(), _pauseButton(), _stopButton()],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => {save()},
                child: Container(
                  height: 50,
                  width: 130,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    color: LightColor.blueLinkedin, //Color(0xff006a71),
                  ),
                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <Widget>[
                    Icon(
                      Icons.cloud_download,
                      color: Colors.white,
                    ),
                    Text(
                      getTranslated(context, 'sauvegarder'),
                      style: TextStyle(color: Colors.white),
                    ),
                  ]),
                ),
              )
            ],
          )
        ],
      );

  void save() {
    if (mounted) {
      setState(() {
        this.audioFile = new File(_recording.path);
        print(_recording.path);
        print(this.audioFile);
      });
    }

    InterventionController().uploadAudio(this.audioFile, context);

    //print(this.widget.audioFile);
    Navigator.pop(context, this.audio_name);
    Utils.showAlertDialog(context, getTranslated(context, 'add_audio'));
  }

  format(Duration d) => d.toString().split('.').first.padLeft(8, "0");
}
