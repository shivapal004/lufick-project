import 'dart:async';
import 'dart:developer';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:authentication_app/screens/audio_player/recordings_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class AudioPlayer extends StatefulWidget {
  const AudioPlayer({super.key});

  @override
  State<AudioPlayer> createState() => _AudioPlayerState();
}

class _AudioPlayerState extends State<AudioPlayer> {

  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  bool _isRecording = false;
  final List<Map<String, dynamic>> _recordings = [];
  late Database _database;
  String? _filePath;
  final RecorderController _recorderController = RecorderController();
  Timer? _timer;
  int _recordDuration = 0;

  @override
  void initState() {
    super.initState();
    _initDb();
    _initRecorder();
    _initPlayer();
  }

  Future<void> _initDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'audio_recordings.db'),
      onCreate: (db, version) {
        return db.execute(
            "CREATE TABLE recordings(id INTEGER PRIMARY KEY, path TEXT, timestamp TEXT, name TEXT)");
      },
      version: 2,
    );
    // _loadRecordings();
  }

  Future<void> _initRecorder() async {
    _recorder = FlutterSoundRecorder();
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      log("Microphone permission not granted!");
      return;
    }
    if (status == PermissionStatus.permanentlyDenied) {
      log(
          "Microphone permission permanently denied! Redirecting to settings.");
      openAppSettings();
      return;
    }
    await _recorder!.openRecorder();
  }

  Future<void> _initPlayer() async {
    _player = FlutterSoundPlayer();
    await _player!.openPlayer();
  }

  Future<void> _startRecording() async {
    _recorderController.record();
    _filePath = join(await getDatabasesPath(),
        '${DateTime.now().millisecondsSinceEpoch}.aac');
    await _recorder!.startRecorder(toFile: _filePath);
    setState(() {
      _isRecording = true;
      _recordDuration = 0;
    });
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _recordDuration++;
      });
    });
  }

  Future<void> _stopRecording() async {
    await _recorder!.stopRecorder();
    await _recorderController.stop();
    _timer?.cancel();
    await _database.insert('recordings', {
      'path': _filePath,
      'timestamp': DateTime.now().toIso8601String(),
    });
    setState(() => _isRecording = false);
    // _loadRecordings();
    await Fluttertoast.showToast(
      msg: "Your recording saved!",
      toastLength: Toast.LENGTH_LONG,
    );
  }







  @override
  void dispose() {
    _recorder!.closeRecorder();
    _player!.closePlayer();
    _recorderController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text("Audio Recorder & Player"),
        actions: [
          IconButton(
            icon: const Icon(Icons.library_music),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RecordingsPage(recordings: _recordings),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 10)),
            child: const CircleAvatar(
              radius: 100,
              backgroundColor: Colors.orange,
              child: Icon(
                CupertinoIcons.mic,
                size: 100,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 25),
          Text(
            _isRecording
                ? "Recording: ${Duration(seconds: _recordDuration).toString().split('.')[0]}"
                : "Record your voice",
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.blueAccent),
          ),
          const SizedBox(height: 20),
          Container(
            height: 80,
            width: MediaQuery.of(context).size.width * 0.8,
            padding: const EdgeInsets.symmetric(horizontal: 10),
            // decoration: BoxDecoration(
            //   color: Colors.white,
            //   // borderRadius: BorderRadius.circular(20),
            //   boxShadow: [
            //     BoxShadow(
            //       color: Colors.black.withOpacity(0.1),
            //       blurRadius: 10,
            //       spreadRadius: 2,
            //     ),
            //   ],
            // ),
            child: Center(
              child: !_isRecording
                  // ? Image.asset('images/wave_image.jpg', width: 500,height: 100,)
                  ? Container()
                  : AudioWaveforms(
                      recorderController: _recorderController,
                      enableGesture: false,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.blue,
                        showMiddleLine: false,
                        waveThickness: 3.5,
                        spacing: 6,
                        extendWaveform: true,
                        showDurationLabel: false,
                        scaleFactor: 200,
                      ),
                      size: Size(_isRecording ? 300 : 0, 60),
                    ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: Colors.blueAccent,
                radius: 40,
                child: IconButton(
                  icon: Icon(_isRecording ? Icons.pause : Icons.play_arrow,
                      color: Colors.white),
                  iconSize: 60,
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                ),
              ),
            ],
          ),


        ],
      ),
    );
  }
}
