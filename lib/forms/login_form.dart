import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:m2dfs_bauchot_pictionary/screens/home.dart';

/// A stateful widget that represents the login form.
class LoginForm extends StatefulWidget {
  /// Creates a LoginForm widget.
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

/// The state for the LoginForm widget.
class _LoginFormState extends State<LoginForm> {
  /// Controller for the username text field.
  final TextEditingController _nameController = TextEditingController();

  /// Controller for the password text field.
  final TextEditingController _passwordController = TextEditingController();

  /// Whether the password is visible or not.
  bool _isPasswordVisible = false;

  /// Whether the "Remember me" checkbox is checked or not.
  bool _rememberMe = false;

  /// Whether the login process is loading or not.
  bool _isLoading = false;

  /// Toggles the visibility of the password.
  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  /// Decodes a JWT token and returns its payload as a Map.
  ///
  /// Throws an exception if the token is invalid.
  ///
  /// - Parameters:
  ///   - token: The JWT token to decode.
  ///
  /// - Returns: A Map containing the payload of the token.
  Map<String, dynamic> decodeJWT(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('Invalid JWT');
    }
    final payload = utf8.decode(base64Url.decode(base64Url.normalize(parts[1])));
    return jsonDecode(payload);
  }

  /// Handles the login process.
  ///
  /// Sends a login request to the server and handles the response.
  /// If the login is successful, stores the user information in shared preferences
  /// and navigates to the home page.
  Future<void> _login() async {
    final String name = _nameController.text.trim();
    final String password = _passwordController.text.trim();

    if (name.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    setState(() => _isLoading = true);

    final String url = '${dotenv.env['API_URL']}/login';

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'password': password}),
    );

    setState(() => _isLoading = false);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final String token = data['token'];
      final decodedToken = decodeJWT(token);
      final String userId = decodedToken['id'].toString();

      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setString('userToken', token);
      await prefs.setString('userId', userId);

      if (_rememberMe) {
        await prefs.setBool('rememberMe', true);
      }

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login failed. Please try again.')),
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
          const SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              Text('Remember me', style: GoogleFonts.poppins(color: Colors.white)),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _login,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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