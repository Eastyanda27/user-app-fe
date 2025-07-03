import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/user_list_screen.dart';
import 'screens/user_detail_screen.dart';
import 'screens/forgot_password_screen.dart';
import 'screens/reset_password_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'User App',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(email: 'example@example.com'),
        '/edit-profile': (context) => const EditProfileScreen(),
        '/users': (context) => const UserListScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/reset-password': (context) {
          final args = ModalRoute.of(context)!.settings.arguments as String;
          return ResetPasswordScreen(token: args);
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/user-detail') {
          final userId = settings.arguments as int;
          return MaterialPageRoute(
            builder: (context) => UserDetailScreen(userId: userId),
          );
        }
        return null;
      },
      home: const LoginScreen(),
    );
  }
}
