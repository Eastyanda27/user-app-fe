```markdown
# User App Frontend – Flutter

A Flutter mobile application for user authentication, profile editing (with image upload), user listing with search and detail view.

## ✅ Requirements

- Flutter SDK (3.x recommended)
- Android Studio or VS Code
- Emulator or real Android device
- Internet permission in Android manifest
>>>>>>> c9db0f4 (finish)

## 🚀 Getting Started

1. **Clone Repository**
   ```bash
=======
   git clone https://github.com/your-username/user-app.git
   cd user-app
>>>>>>> c9db0f4 (finish)
Install Dependencies

bash
Copy
Edit
=======
flutter pub get
Run the App
>>>>>>> c9db0f4 (finish)

bash
Copy
Edit

=======
flutter run
📱 Features
✅ Register

✅ Login (with token storage)

✅ Update profile (name, password, avatar)

✅ List users + search

✅ Detail user (with avatar)

✅ Logout

⏳ Forgot password (optional)

🔧 Notes
Emulator: use http://10.0.2.2:8000 as base URL to access Laravel backend.

Real device: replace with your local IP address (e.g., http://192.168.x.x:8000).

📁 Project Structure
/screens: All app screens (Login, Register, Home, EditProfile, UserList, UserDetail)

/services/api_service.dart: API calls

main.dart: Route definitions and app entry

📸 Avatar Upload Notes
Image is picked using image_picker and uploaded via http.MultipartRequest

After update, user sees confirmation message

🛠 Dependencies
http

shared_preferences

image_picker

🧪 Testing
Make sure Laravel backend is running at http://10.0.2.2:8000

Register and login to test API

Use tools like Postman for manual API testing
>>>>>>> c9db0f4 (finish)
