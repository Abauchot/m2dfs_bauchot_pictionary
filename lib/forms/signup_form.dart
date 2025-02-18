import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m2dfs_bauchot_pictionary/screens/home.dart';

/// A stateful widget that represents the signup form.
class SignupForm extends StatefulWidget {
  /// Creates a SignupForm widget.
  const SignupForm({super.key});

  @override
  _SignupFormState createState() => _SignupFormState();
}

/// The state for the SignupForm widget.
class _SignupFormState extends State<SignupForm> {
  /// Controller for the username text field.
  final TextEditingController _nameController = TextEditingController();

  /// Controller for the password text field.
  final TextEditingController _passwordController = TextEditingController();

  /// Whether the password is visible or not.
  bool _isPasswordVisible = false;

  /// Whether the signup process is loading or not.
  bool _isLoading = false;

  /// Toggles the visibility of the password.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  /// Handles the signup process.
  ///
  /// Sends a signup request to the server and handles the response.
  /// If the signup is successful, stores the user information in shared preferences
  /// and navigates to the home page.
  Future<void> _signup() async {
    final String name = _nameController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final String url = '${dotenv.env['API_URL']}/players';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'password': password}),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      if (data['token'] != null) {
        await prefs.setString('userToken', data['token']);
      } else {
        await prefs.remove('userToken');
      }

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error during registration. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          _buildTextField(controller: _nameController, label: 'Username'),
          const SizedBox(height: 20),
          _buildTextField(
            controller: _passwordController,
            label: 'Password',
            isPassword: true,
            toggleVisibility: _togglePasswordVisibility,
            isPasswordVisible: _isPasswordVisible,
          ),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _signup,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Sign Up', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds a text field with the specified parameters.
  ///
  /// - Parameters:
  ///   - controller: The controller for the text field.
  ///   - label: The label for the text field.
  ///   - isPassword: Whether the text field is for a password.
  ///   - isPasswordVisible: Whether the password is visible.
  ///   - toggleVisibility: The callback to toggle the password visibility.
  ///
  /// - Returns: A Widget representing the text field.
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    bool isPassword = false,
    bool isPasswordVisible = false,
    VoidCallback? toggleVisibility,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? !isPasswordVisible : false,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(isPasswordVisible ? Icons.visibility : Icons.visibility_off, color: Colors.white),
          onPressed: toggleVisibility,
        )
            : null,
      ),
      style: GoogleFonts.poppins(fontSize: 16, color: Colors.white),
    );
  }
}