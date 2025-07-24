import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  final TextEditingController _messageController = TextEditingController();
  List<Map<String, String>> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final snapshot = await FirebaseFirestore.instance.collection('contacts').get();
    final loadedContacts = snapshot.docs
        .map((doc) => {
              'name': doc['name'] as String,
              'number': doc['number'] as String,
            })
        .toList();

    setState(() {
      _contacts = loadedContacts;
    });
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return null;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.deniedForever) return null;
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission != LocationPermission.whileInUse &&
          permission != LocationPermission.always) return null;
    }

    return await Geolocator.getCurrentPosition();
  }

  Future<void> _sendSOSMessage(String message) async {
    final location = await _getCurrentLocation();
    String fullMessage = message;

    if (location != null) {
      fullMessage +=
          "\nMy location: https://maps.google.com/?q=${location.latitude},${location.longitude}";
    }

    for (var contact in _contacts) {
      final number = contact['number']!;
      final smsUri = Uri.parse("sms:$number?body=${Uri.encodeComponent(fullMessage)}");
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
      }
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('SOS message sent')),
    );
  }

  void _handleSendCustomMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      _sendSOSMessage(message);
      _messageController.clear();
    }
  }

  Widget _buildPredefinedMessage(String text) {
    return GestureDetector(
      onTap: () => _sendSOSMessage(text),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Send an emergency message with your location to your saved contacts.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _messageController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Type your custom message here...',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _handleSendCustomMessage,
              icon: const Icon(Icons.send),
              label: const Text('Send Message'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
              ),
            ),
            const SizedBox(height: 30),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Quick Messages:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
            const SizedBox(height: 10),
            _buildPredefinedMessage("I need help urgently. Please call me!"),
            _buildPredefinedMessage("Emergency! Here's my location."),
            _buildPredefinedMessage("Please track me. I feel unsafe right now."),
          ],
        ),
      ),
    );
  }
}
