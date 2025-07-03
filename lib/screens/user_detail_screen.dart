import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserDetailScreen extends StatefulWidget {
  final int userId;
  const UserDetailScreen({super.key, required this.userId});

  @override
  State<UserDetailScreen> createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  Map<String, dynamic>? user;
  bool isLoading = true;

  Future<void> fetchUserDetail() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse("http://10.0.2.2:8000/api/users/${widget.userId}");

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      setState(() {
        user = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetail();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User Detail")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text("User not found"))
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (user!['avatar_url'] != null)
                    Center(
                      child: ClipOval(
                        child: Image.network(
                          user!['avatar_url'],
                          height: 100,
                          width: 100,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Icon(Icons.error, size: 100);
                          },
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                  Text(
                    "Name: ${user!['name']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "Email: ${user!['email']}",
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            ),
    );
  }
}
