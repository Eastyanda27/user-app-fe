import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  final String email;

  const HomeScreen({super.key, required this.email});

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Hapus token
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, $email'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/users');
              },
              child: const Text('List Users'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/edit-profile');
              },
              child: const Text('Edit Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => logout(context),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
