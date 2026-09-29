import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddDataScreen extends StatefulWidget {
  const AddDataScreen({super.key});

  @override
  _AddDataScreenState createState() => _AddDataScreenState();
}

class _AddDataScreenState extends State<AddDataScreen> {
  final _nameController = TextEditingController();
  final _detailsController = TextEditingController();
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  void _saveData() async {
    if (_nameController.text.isEmpty || _detailsController.text.isEmpty) return;
    
    try {
      await _firestore.collection('user_submissions').add({
        'userId': _auth.currentUser?.uid,
        'name': _nameController.text.trim(),
        'details': _detailsController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });
      
      _nameController.clear();
      _detailsController.clear();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Saved to Firestore successfully!')),
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(controller: _nameController, decoration: const InputDecoration(labelText: 'Name')),
          TextField(controller: _detailsController, decoration: const InputDecoration(labelText: 'Details')),
          const SizedBox(height: 20),
          ElevatedButton(onPressed: _saveData, child: const Text('Save Data')),
        ],
      ),
    );
  }
}