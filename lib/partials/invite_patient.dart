import 'package:flutter/material.dart';

class InvitePatient extends StatefulWidget {
  @override
  _InvitePatientState createState() => _InvitePatientState();
}

class _InvitePatientState extends State<InvitePatient> {
  final _emailController = TextEditingController();

  void _invite() {
    // Here you can implement the invite functionality
    Navigator.of(context).pop(); // Close the popup
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Invite Patient',
          style: TextStyle(color: Theme.of(context).primaryColor)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              labelStyle: TextStyle(color: Theme.of(context).primaryColor),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Theme.of(context).primaryColor),
              ),
            ),
            cursorColor: Theme.of(context).primaryColor,
          ),
        ],
      ),
      actions: [
        Center(
          child: ElevatedButton(
            onPressed: _invite,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            child: Text(
              'Invite',
              style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
            ),
          ),
        ),
      ],
    );
  }
}
