import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:m2dfs_bauchot_pictionary/screens/login.dart';
import 'package:m2dfs_bauchot_pictionary/screens/signup.dart';
import 'package:m2dfs_bauchot_pictionary/screens/start_game.dart';

/// The home page of the Pictionary app.
class HomePage extends StatefulWidget {
  /// Creates a new HomePage instance.
  ///
  /// - Parameters:
  ///   - key: An optional key for the widget.
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

/// The state for the HomePage widget.
class _HomePageState extends State<HomePage> {
  /// Indicates whether the user is logged in.
  bool _isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  /// Checks the login status of the user.
  ///
  /// - Returns: A Future that completes when the operation is done.
  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getString('userToken') != null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Pictionary',
                  style: GoogleFonts.poppins(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'draw and guess, have fun with your friends!',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                _buildButton(
                  text: 'Connexion',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Login()),
                  ),
                ),
                const SizedBox(height: 20),
                _buildButton(
                  text: 'Inscription',
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()),
                  ),
                ),
                if (_isLoggedIn) ...[
                  const SizedBox(height: 20),
                  _buildButton(
                    text: 'Create a game',
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => StartGame()),
                    ),
                    color: Colors.greenAccent,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds a button widget.
  ///
  /// - Parameters:
  ///   - text: The text to display on the button.
  ///   - onTap: The callback to invoke when the button is tapped.
  ///   - color: The background color of the button (optional).
  ///
  /// - Returns: A Widget representing the button.
  Widget _buildButton({required String text, required VoidCallback onTap, Color? color}) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? Colors.white,
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}