import 'package:flutter/material.dart';
import '../models/ladder_item.dart';

class SettingsScreen extends StatefulWidget {
  final List<LadderItem> initialLadder;
  final List<String> allowedApps;

  const SettingsScreen({
    super.key,
    required this.initialLadder,
    required this.allowedApps,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late List<LadderItem> _mutableLadder;
  late List<String> _mutableApps;
  final TextEditingController _workController = TextEditingController();
  final TextEditingController _restController = TextEditingController();
  final TextEditingController _appController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _mutableLadder = List.from(widget.initialLadder);
    _mutableApps = List.from(widget.allowedApps);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configure Ladder & Zen Apps')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ladder Intervals:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _mutableLadder.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;
                return Chip(
                  label: Text('${item.isWork ? "Work" : "Rest"}: ${item.duration}m'),
                  backgroundColor: item.isWork ? Colors.indigo.withOpacity(0.4) : Colors.teal.withOpacity(0.4),
                  onDeleted: () => setState(() => _mutableLadder.removeAt(index)),
                );
              }).toList(),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _workController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Work mins', filled: true),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_workController.text.isNotEmpty) {
                      setState(() {
                        _mutableLadder.add(LadderItem(isWork: true, duration: int.parse(_workController.text)));
                        _workController.clear();
                      });
                    }
                  },
                  child: const Text('Add Work'),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _restController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(hintText: 'Rest mins', filled: true),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
                  onPressed: () {
                    if (_restController.text.isNotEmpty) {
                      setState(() {
                        _mutableLadder.add(LadderItem(isWork: false, duration: int.parse(_restController.text)));
                        _restController.clear();
                      });
                    }
                  },
                  child: const Text('Add Rest'),
                ),
              ],
            ),
            const SizedBox(height: 30),
            const Text('Zen Mode Whitelisted Apps:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: _mutableApps.map((app) => Chip(
                label: Text(app),
                onDeleted: () => setState(() => _mutableApps.remove(app)),
              )).toList(),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _appController,
                    decoration: const InputDecoration(hintText: 'App name (e.g., Spotify)', filled: true),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle, color: Colors.indigoAccent, size: 36),
                  onPressed: () {
                    if (_appController.text.isNotEmpty) {
                      setState(() {
                        _mutableApps.add(_appController.text);
                        _appController.clear();
                      });
                    }
                  },
                )
              ],
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50), backgroundColor: Colors.indigoAccent),
              onPressed: () => Navigator.pop(context, {'ladder': _mutableLadder, 'apps': _mutableApps}),
              child: const Text('Save & Apply Settings', style: TextStyle(fontWeight: FontWeight.bold)),
            )
          ],
        ),
      ),
    );
  }
}