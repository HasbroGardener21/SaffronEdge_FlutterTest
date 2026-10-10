import 'dart:async';
import 'package:flutter/material.dart';
import '../models/ladder_item.dart';
import '../widgets/timer_display.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _currentIndex = 0;
  List<LadderItem> _ladder = [
    LadderItem(isWork: true, duration: 50),
    LadderItem(isWork: false, duration: 10),
    LadderItem(isWork: true, duration: 40),
    LadderItem(isWork: false, duration: 10),
  ];

  List<String> _favoriteApps = ['Phone', 'Messages', 'Calculator', 'Spotify'];

  late int _remainingSeconds;
  Timer? _timer;
  bool _isRunning = false;
  DateTime? _pausedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _remainingSeconds = _ladder[_currentIndex].duration * 60;
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused && _isRunning) {
      _pausedTime = DateTime.now();
    } else if (state == AppLifecycleState.resumed && _isRunning && _pausedTime != null) {
      final difference = DateTime.now().difference(_pausedTime!).inSeconds;
      setState(() {
        if (_remainingSeconds > difference) {
          _remainingSeconds -= difference;
        } else {
          _remainingSeconds = 0;
          _timer?.cancel();
          _isRunning = false;
          _moveToNextInterval();
        }
      });
      _pausedTime = null;
    }
  }

  void _startTimer() {
    if (_isRunning) return;
    setState(() => _isRunning = true);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;
        } else {
          _timer?.cancel();
          _isRunning = false;
          _moveToNextInterval();
        }
      });
    });
  }

  void _pauseTimer() {
    _timer?.cancel();
    setState(() => _isRunning = false);
  }

  void _moveToNextInterval() {
    if (_currentIndex < _ladder.length - 1) {
      setState(() {
        _currentIndex++;
        _remainingSeconds = _ladder[_currentIndex].duration * 60;
      });
      _startTimer();
    } else {
      setState(() => _currentIndex = 0);
    }
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  void _openSettings() async {
    _pauseTimer();
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SettingsScreen(initialLadder: _ladder, allowedApps: _favoriteApps)),
    );
    if (result != null) {
      setState(() {
        _ladder = result['ladder'];
        _favoriteApps = result['apps'];
        _currentIndex = 0;
        _remainingSeconds = _ladder[0].duration * 60;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isWork = _ladder[_currentIndex].isWork;
    double progress = 1.0 - (_remainingSeconds / (_ladder[_currentIndex].duration * 60));

    return Scaffold(
      appBar: AppBar(
        title: const Text('ZenLadder', style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: _openSettings,
          )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: (isWork ? Colors.indigo : Colors.teal).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isWork ? Colors.indigoAccent : Colors.tealAccent, width: 1.5),
                ),
                child: Text(
                  isWork ? 'FOCUS BLOCK' : 'REST BREAK',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                    color: isWork ? Colors.indigoAccent : Colors.tealAccent,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              TimerDisplay(
                progress: progress,
                timeText: _formatTime(_remainingSeconds),
                isWork: isWork,
              ),
              const SizedBox(height: 40),
              if (isWork && _isRunning) ...[
                const Text('Zen Mode Active: Allowed Apps Only', style: TextStyle(color: Colors.white54, fontSize: 12)),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _favoriteApps.map((app) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Chip(label: Text(app), backgroundColor: Colors.indigo.withOpacity(0.3)),
                  )).toList(),
                ),
              ],
              const SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                      backgroundColor: isWork ? Colors.indigo : Colors.teal,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: _isRunning ? _pauseTimer : _startTimer,
                    child: Text(_isRunning ? 'PAUSE' : 'START', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(width: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      _pauseTimer();
                      setState(() {
                        _currentIndex = 0;
                        _remainingSeconds = _ladder[0].duration * 60;
                      });
                    },
                    child: const Text('RESET', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}