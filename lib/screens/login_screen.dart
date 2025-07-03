import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? error;

  void handleLogin() async {
    setState(() {
      isLoading = true;
      error = null;
    });

    try {
      final result = await ApiService.login(
        emailController.text,
        passwordController.text,
      );

      final token = result['token']; // Asumsikan response-nya {token: ...}

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(email: emailController.text),
        ),
      );
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (error != null)
              Text(error!, style: TextStyle(color: Colors.red)),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Password'),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: handleLogin,
                    child: const Text('Login'),
                  ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/register');
              },
              child: const Text("Belum punya akun? Daftar di sini"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/forgot-password');
              },
              child: const Text("Lupa password?"),
            ),
          ],
        ),
      ),
    );
  }
}
