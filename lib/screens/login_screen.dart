import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'create_profile_screen.dart';
import 'timetable_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      List<String> users = prefs.getStringList('users') ?? [];

      bool userFound = false;

      for (String user in users) {
        Map<String, String> userData = Map<String, String>.from(
          Map.castFrom<dynamic, dynamic, String, String>(
            user.replaceAll(RegExp(r'[{} ]'), '').split(',').fold({}, (map, item) {
              var pair = item.split(':');
              map[pair[0]] = pair[1];
              return map;
            }),
          ),
        );

        if (userData['email'] == email && userData['password'] == password) {
          userFound = true;
          break;
        }
      }

      if (userFound) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login successful')),
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TimetableScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid credentials')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again.')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
              ),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: "Password"),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _login,
                      child: Text("Login"),
                    ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProfileCreationScreen()),
                  );
                },
                child: Text("Don't have an account? Create one"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
