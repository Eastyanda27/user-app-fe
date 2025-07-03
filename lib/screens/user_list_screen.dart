import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List users = [];
  bool isLoading = true;
  String search = "";
  int currentPage = 1;
  int lastPage = 1;

  Future<void> fetchUsers({int page = 1}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final url = Uri.parse(
      "http://10.0.2.2:8000/api/users?search=$search&page=$page",
    );

    final response = await http.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        users = data['data'];
        currentPage = data['current_page'];
        lastPage = data['last_page'];
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
    fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("List User")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (val) {
                setState(() {
                  search = val;
                  isLoading = true;
                });
                fetchUsers();
              },
              decoration: const InputDecoration(
                labelText: "Search user...",
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, index) {
                            final user = users[index];
                            return ListTile(
                              title: Text(user['name']),
                              subtitle: Text(user['email']),
                              onTap: () {
                                Navigator.pushNamed(
                                  context,
                                  '/user-detail',
                                  arguments: user['id'],
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: currentPage > 1
                                ? () => fetchUsers(page: currentPage - 1)
                                : null,
                            child: const Text('Previous'),
                          ),
                          const SizedBox(width: 16),
                          Text('Page $currentPage of $lastPage'),
                          const SizedBox(width: 16),
                          ElevatedButton(
                            onPressed: currentPage < lastPage
                                ? () => fetchUsers(page: currentPage + 1)
                                : null,
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
