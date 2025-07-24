import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Women Safety App'),
        backgroundColor: Colors.white,
        foregroundColor: const Color.fromARGB(255, 196, 121, 121),
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            _buildButton(
              context: context,
              label: 'Live Map',
              icon: Icons.map_outlined,
              color: Colors.green.shade700,
              route: '/map',
            ),
            const SizedBox(height: 20),
            _buildButton(
              context: context,
              label: 'SOS',
              icon: Icons.warning_amber_outlined,
              color: Colors.red.shade600,
              route: '/sos',
            ),
            const SizedBox(height: 20),
            _buildButton(
              context: context,
              label: 'Emergency Contacts',
              icon: Icons.contacts_outlined,
              color: Colors.blue.shade700,
              route: '/contacts',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required Color color,
    required String route,
  }) {
    return ElevatedButton.icon(
      onPressed: () {
        Navigator.pushNamed(context, route);
      },
      icon: Icon(icon, size: 28),
      label: Text(
        label,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 2,
      ),
    );
  }
}
