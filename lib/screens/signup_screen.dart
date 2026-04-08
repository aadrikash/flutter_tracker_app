import 'package:flutter/material.dart';
import '../services/auth_service.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userController = TextEditingController();
  final passController = TextEditingController();

  void register() {
    bool success =
        AuthService.instance.register(userController.text, passController.text);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Account Created Successfully")));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Username already exists")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient:
              LinearGradient(colors: [Colors.deepPurple, Colors.purpleAccent]),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 25),
              padding: EdgeInsets.all(25),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  Text("Sign Up",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  SizedBox(height: 25),
                  TextField(
                    controller: userController,
                    decoration: InputDecoration(
                        labelText: "Username", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    controller: passController,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: "Password", border: OutlineInputBorder()),
                  ),
                  SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: register,
                      child: Text("Create Account"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
