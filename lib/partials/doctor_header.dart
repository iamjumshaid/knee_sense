import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../login_screen.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  AppHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;

    void _logout() async {
      await _auth.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false,
      );
    }

    return AppBar(
      backgroundColor: Theme.of(context).primaryColor,
      title: Row(
        children: [
          ClipRRect(
            borderRadius:
                BorderRadius.circular(40), // Adjust the radius as needed
            child: Image.asset(
              'assets/logo.png',
              height: 40,
            ),
          ),
          SizedBox(width: 10),
          Text(title,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary,
              )),
        ],
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.search),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: () {
            // Implement search functionality here
          },
        ),
        IconButton(
          icon: Icon(Icons.logout),
          color: Theme.of(context).colorScheme.onPrimary,
          onPressed: _logout,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
