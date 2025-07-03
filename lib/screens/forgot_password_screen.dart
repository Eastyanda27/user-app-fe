import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController();
  bool isLoading = false;
  String? message;

  Future<void> sendResetEmail() async {
    setState(() {
      isLoading = true;
      message = null;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:8000/api/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': emailController.text}),
    );

    final data = json.decode(response.body);
    setState(() {
      isLoading = false;
      message = data['message'] ?? 'Permintaan gagal';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Lupa Password")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (message != null) ...[
              Text(message!, style: const TextStyle(color: Colors.blue)),
              const SizedBox(height: 10),
            ],
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Masukkan Email'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: sendResetEmail,
                    child: const Text('Kirim Link Reset'),
                  ),
          ],
        ),
      ),
    );
  }
}
