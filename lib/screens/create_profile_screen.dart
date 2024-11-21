import 'package:flutter/material.dart';

class ProfileCreationScreen extends StatefulWidget {
  @override
  _ProfileCreationScreenState createState() => _ProfileCreationScreenState();
}

class _ProfileCreationScreenState extends State<ProfileCreationScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _createProfile() async {
    // Accessing context inside the method in a StatefulWidget
    final String username = _usernameController.text;
    final String email = _emailController.text;
    final String password = _passwordController.text;

    // Simulate creating the profile
    print("Creating profile with username: $username, email: $email, password: $password");

    // For now, just navigate back to the login screen
    Navigator.pop(context);  // context is valid here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Profile")),
      body: Column(
        children: [
          // TextFields for username, email, and password
          TextField(controller: _usernameController, decoration: InputDecoration(labelText: "Username")),
          TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email")),
          TextField(controller: _passwordController, decoration: InputDecoration(labelText: "Password")),
          ElevatedButton(
            onPressed: _createProfile, // Call method to create profile
            child: Text("Create Profile"),
          ),
        ],
      ),
    );
  }
}
