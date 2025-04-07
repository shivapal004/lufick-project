import 'dart:developer';
import 'dart:io';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sqflite/sqflite.dart';

class RecordingsPage extends StatefulWidget {
  final List<Map<String, dynamic>> recordings;

  const RecordingsPage({super.key, required this.recordings});

  @override
  State<RecordingsPage> createState() => _RecordingsPageState();
}

class _RecordingsPageState extends State<RecordingsPage> {
  final RecorderController _recorderController = RecorderController();
  int? _playingIndex;

  // final List<String?> _durations = [];
  List<Map<String, dynamic>> _recordings = [];
  late Database _database;

  // FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _filteredRecordings = [];

  @override
  void initState() {
    super.initState();
    _initDb();
    // _initRecorder();
    _initPlayer();
    _player?.openPlayer();
    _searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRecordings = _recordings.where((recording) {
        final name = (recording['name'] ?? 'Recording ${recording['id']}').toLowerCase();
        return name.contains(query);
      }).toList();
    });
  }

  Future<void> _initDb() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'audio_recordings.db'),
    );
    _loadRecordings();
    // _loadDurations();
  }

  // Future<void> _initRecorder() async {
  //   _recorder = FlutterSoundRecorder();
  //   PermissionStatus status = await Permission.microphone.request();
  //   if (status != PermissionStatus.granted) {
  //     log("Microphone permission not granted!");
  //     return;
  //   }
  //   if (status == PermissionStatus.permanentlyDenied) {
  //     log(
  //         "Microphone permission permanently denied! Redirecting to settings.");
  //     openAppSettings();
  //     return;
  //   }
  //   await _recorder!.openRecorder();
  // }

  Future<void> _initPlayer() async {
    _player = FlutterSoundPlayer();
    await _player!.openPlayer();
  }

  Future<void> _loadRecordings() async {
    final List<Map<String, dynamic>> recordings =
    await _database.query('recordings');
    setState(() {
      _recordings = recordings;
      _filteredRecordings = recordings;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _player?.closePlayer();

    _recorderController.dispose();
    super.dispose();
    // _loadDurations();
  }

  // Future<void> _loadDurations() async {
  //   for (var recording in _recordings) {
  //     final player = AudioPlayer();
  //     try {
  //       await player.setFilePath(recording['path']);
  //       final duration = player.duration;
  //       _durations.add(_formatDuration(duration));
  //     } catch (e) {
  //       _durations.add(null);
  //     } finally {
  //       await player.dispose();
  //     }
  //     setState(() {});
  //   }
  // }

  Future<void> _playPause(int index, String path) async {
    if (_playingIndex == index) {
      await _recorderController.stop();
      await _player?.stopPlayer();
      setState(() {
        _playingIndex = null;
      });
    } else {
      await _recorderController.record();
      await _player?.startPlayer(
        fromURI: path,
        whenFinished: () {
          setState(() {
            _playingIndex = null;
          });
        },
      );
      setState(() {
        _playingIndex = index;
      });
    }
  }

  // Future<void> _playRecording(int index, String path) async {
  //   if (_playingIndex == index) {
  //     await _stopPlaying();
  //     return;
  //   }
  //   await _player!.startPlayer(
  //     fromURI: path,
  //     whenFinished: () {
  //       setState(() {
  //         _playingIndex = null;
  //       });
  //     },
  //   );
  //   setState(() {
  //     _playingIndex = index;
  //   });
  // }

  // Future<void> _stopPlaying() async {
  //   await _player!.stopPlayer();
  //   setState(() {
  //     _playingIndex = null;
  //   });
  // }

  Future<void> _deleteRecording(int id, String path) async {
    await _database.delete('recordings', where: 'id = ?', whereArgs: [id]);
    File file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
    await _loadRecordings();
    // await _loadDurations();
  }

  String _formatDate(String? timestamp) {
    if (timestamp == null) return '';
    final date = DateTime.parse(timestamp);
    final formattedDate = "${date.day.toString().padLeft(2, '0')} "
        "${_getMonth(date.month)} "
        "${date.year} | "
        "${_formatTime(date)}";
    return formattedDate;
  }

  String _getMonth(int month) {
    const months = [
      '',
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month];
  }

  String _formatTime(DateTime date) {
    int hour = date.hour;
    final minute = date.minute.toString().padLeft(2, '0');
    final suffix = hour >= 12 ? 'pm' : 'am';
    hour = hour % 12 == 0 ? 12 : hour % 12;
    return '${hour.toString().padLeft(2, '0')}:$minute $suffix';
  }

  // String _formatDuration(Duration? duration) {
  //   if (duration == null) return '';
  //   final minutes = duration.inMinutes.toString().padLeft(2, '0');
  //   final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
  //   return '$minutes:$seconds';
  // }

  Future<void> _renameRecording(int id, String currentName,
      BuildContext context) async {
    final TextEditingController controller = TextEditingController(
        text: currentName);

    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Rename Recording'),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: 'Enter new name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () async {
                  final newName = controller.text.trim();
                  if (newName.isNotEmpty) {
                    await _database.update(
                      'recordings',
                      {'name': newName},
                      where: 'id = ?',
                      whereArgs: [id],
                    );
                    await _loadRecordings();
                    Navigator.pop(context);
                  }
                },
                child: const Text('Rename'),
              ),
            ],
          ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text('Saved Recordings'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: 'Search recordings...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          Expanded(
            child: _filteredRecordings.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.mic_off, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No recordings available',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            )
                : ListView.builder(
              itemCount: _filteredRecordings.length,
              itemBuilder: (context, index) {
                final recording = _filteredRecordings[index];
                return Card(
                  color: Colors.white,
                  elevation: 3,
                  margin:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    onLongPress: () {
                      _renameRecording(_recordings[index]['id'],
                          _recordings[index]['name'] ??
                              'Recording ${_recordings[index]['id']}', context);
                    },
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue[100],
                      radius: 25,
                      child: InkWell(
                        onTap: () {
                          _playPause(index, recording['path']);
                        },
                        child: Icon(
                          _playingIndex == index
                              ? Icons.pause
                              : Icons.play_arrow,
                          color: Colors.black,
                          size: 30,
                        ),
                      ),
                    ),
                    title: Text(
                      recording['name'] ?? 'Recording ${recording['id']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle:
                    _playingIndex == index
                        ? AudioWaveforms(
                      recorderController: _recorderController,
                      enableGesture: true,
                      waveStyle: const WaveStyle(
                        waveColor: Colors.blue,
                        showMiddleLine: false,
                        waveThickness: 3.5,
                        spacing: 5,
                        extendWaveform: true,
                        showDurationLabel: false,
                        // scaleFactor: 50,
                      ),
                      size: const Size(10, 10),
                    )
                        :
                    Text(
                      _formatDate(recording['timestamp']),
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        await _deleteRecording(
                          _recordings[index]['id'],
                          _recordings[index]['path'],
                        );
                        setState(() {});
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
