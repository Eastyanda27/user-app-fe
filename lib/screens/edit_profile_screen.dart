import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  XFile? _pickedFile;
  bool isLoading = false;
  String? message;

  Future<void> pickImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _pickedFile = picked;
      });
    }
  }

  Future<void> updateProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    if (token == null) return;

    setState(() {
      isLoading = true;
      message = null;
    });

    final uri = Uri.parse('http://10.0.2.2:8000/api/user?_method=PUT');
    final request = http.MultipartRequest('POST', uri);
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['name'] = nameController.text;
    if (passwordController.text.isNotEmpty) {
      request.fields['password'] = passwordController.text;
    }

    if (_pickedFile != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'avatar',
          await _pickedFile!.readAsBytes(),
          filename: _pickedFile!.name,
          contentType: MediaType('image', 'jpeg'),
        ),
      );
    }

    try {
      final streamed = await request.send();
      final response = await http.Response.fromStream(streamed);

      print('Response code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setState(() => message = "Profile updated successfully");
      } else {
        setState(() => message = "Failed to update profile: ${response.body}");
      }
    } catch (e) {
      print('Error during update: $e');
      setState(() => message = 'Error: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            if (message != null)
              Text(message!, style: const TextStyle(color: Colors.green)),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(
                labelText: 'New Password (optional)',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 10),
            _pickedFile != null
                ? Text(
                    'File: ${_pickedFile!.name}',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  )
                : const Text('No image selected'),
            TextButton.icon(
              onPressed: pickImage,
              icon: const Icon(Icons.image),
              label: const Text("Choose Avatar"),
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : ElevatedButton(
                    onPressed: updateProfile,
                    child: const Text('Update Profile'),
                  ),
          ],
        ),
      ),
    );
  }
}
