import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:m2dfs_bauchot_pictionary/screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2dfs_bauchot_pictionary/utils/theme.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  Future<void> _login() async {
    final String name = _nameController.text;
    final String password = _passwordController.text;

    if (name.isEmpty || password.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Veuillez remplir tous les champs requis.'),
          ),
        );
      }
      return;
    }

    final String url = '${dotenv.env['API_URL']}/login';
    print('Attempting to login with URL: $url');
    print('Name: $name, Password: $password');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'name': name, 'password': password}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', name);
      await prefs.setString('userToken', data['token']);
      if (_rememberMe) {
        await prefs.setBool('rememberMe', true);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connexion réussie!'),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Échec de la connexion. Veuillez réessayer.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _nameController,
            style: const TextStyle(color: AppTheme.primaryBlue),
            decoration: const InputDecoration(
              labelText: 'Name',
              labelStyle: TextStyle(color: AppTheme.primaryBlue),
              prefixIcon: Icon(Icons.person, color: AppTheme.primaryBlue),
            ),
          ),
          const SizedBox(height: 16.0),
          TextField(
            controller: _passwordController,
            style: const TextStyle(color: AppTheme.primaryBlue),
            decoration: InputDecoration(
              labelText: 'Password',
              labelStyle: const TextStyle(color: AppTheme.primaryBlue),
              prefixIcon: const Icon(Icons.lock, color: AppTheme.primaryBlue),
              suffixIcon: IconButton(
                icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility, color: AppTheme.primaryBlue),
                onPressed: _togglePasswordVisibility,
              ),
            ),
            obscureText: !_isPasswordVisible,
          ),
          const SizedBox(height: 16.0),
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
              const Text('Remember me', style: TextStyle(color: AppTheme.primaryBlue)),
            ],
          ),
          const SizedBox(height: 16.0),
          ElevatedButton(
            onPressed: _login,
            child: const Text('login'),
          ),
        ],
      ),
    );
  }
}