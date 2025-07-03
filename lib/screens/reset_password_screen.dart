import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ResetPasswordScreen extends StatefulWidget {
  final String token;

  const ResetPasswordScreen({super.key, required this.token});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool isLoading = false;
  String? message;

  Future<void> resetPassword() async {
    setState(() {
      isLoading = true;
      message = null;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'token': widget.token,
        'password': passwordController.text,
        'password_confirmation': confirmPasswordController.text,
      }),
    );

    final data = json.decode(response.body);
    setState(() {
      isLoading = false;
      message = data['message'] ?? 'Gagal reset password';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Reset Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (message != null)
              Text(message!, style: const TextStyle(color: Colors.green)),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password Baru'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration: const InputDecoration(
                labelText: 'Konfirmasi Password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: resetPassword,
                    child: const Text('Reset Password'),
                  ),
          ],
        ),
      ),
    );
  }
}
