import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../secrets.dart'; // Add this import for making HTTP requests

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _obscurePassword = true;

  // Function to send the password reset request
  void _resetPassword() async {
    if (_newPasswordController.text != _confirmPasswordController.text) {
      // Passwords don't match
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Passwords do not match."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      return;
    }

    // Send the password reset request to your backend
    final response = await http.post(
      Uri.parse("$API_URL/auth/forgot-password"),
      body: {
        "email": _emailController.text,
        "newPassword": _newPasswordController.text,
      },
    );

    if (response.statusCode == 200) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Success"),
          content: Text("Please check your mail to complete reset."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
      // Clear the text fields
      _emailController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text("Password reset failed. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Forget Password"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset(
                    "assets/logo_app.png",
                    height: 100,
                    width: 100,
                  ),
                  const Center(
                    child: Text(
                      "AIMS",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: 30.0), // Add bottom padding here
                    child: Center(
                      child: Text(
                        "Cut the middle man between farmers and wholesalers",
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: _emailController,
                      keyboardType:
                          TextInputType.emailAddress, // Use email keyboard type
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        labelText: "Email", // Label for the email field
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextFormField(
                      controller: _newPasswordController,
                      obscureText: !_obscurePassword,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        labelText: "New Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.0),
                      border: Border.all(color: Colors.grey),
                    ),
                    child: TextField(
                      controller: _confirmPasswordController,
                      obscureText: !_obscurePassword,
                      decoration: InputDecoration(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10.0),
                        labelText: "Confirm Password",
                        border: InputBorder.none,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed:
                        _resetPassword, // Call the reset password function
                    style: ElevatedButton.styleFrom(
                     // primary: Colors.green, // Button background color
                      foregroundColor: Colors.green, shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                            20.0), // Set the border radius
                        side: BorderSide(
                            color: Colors.green), // Set the border color
                      ),
                    ),
                    child: Container(
                      width: double
                          .infinity, // Make the button span the full width
                      padding: EdgeInsets.symmetric(
                          vertical: 16.0), // Adjust vertical padding
                      alignment:
                          Alignment.center, // Center the text inside the button
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                            fontSize: 16.0), // Adjust font size if needed
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
