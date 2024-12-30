import 'package:flutter/material.dart';
import 'package:m2dfs_bauchot_pictionary/screens/login.dart';
import 'package:m2dfs_bauchot_pictionary/screens/signup.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pictionary'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
               Navigator.push(
                   context,
                    MaterialPageRoute(builder: (context) => Login()
               ));
              },
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SignUp()
                ));
              },
              child: Text('Sign Up'),
            ),
          ],
        ),
      ),
    );
  }
}