import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String? message;

  Future<void> register() async {
    setState(() {
      isLoading = true;
      message = null;
    });

    final url = Uri.parse('http://10.0.2.2:8000/api/register');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': nameController.text,
        'email': emailController.text,
        'password': passwordController.text,
      }),
    );

    final data = json.decode(response.body);
    setState(() {
      isLoading = false;
    });

    if (response.statusCode == 200) {
      setState(() {
        message = "Register berhasil! Silakan login.";
      });
    } else {
      setState(() {
        message = data['message'] ?? 'Gagal register.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (message != null) ...[
              Text(message!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 10),
            ],
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: register, child: Text('Register')),
          ],
        ),
      ),
    );
  }
}
