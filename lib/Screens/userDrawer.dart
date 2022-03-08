import 'package:flutter/material.dart';
import 'package:password_verifications_app/Screens/getUsers.dart';
import 'package:password_verifications_app/Screens/registerUser.dart';

class userDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return userDrawerState();
  }
}

class userDrawerState extends State<userDrawer> {
  final minimumPadding = 5.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Management"),
      ),
      body: Center(
        child: Text("Welcome to the app"),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.only(top: minimumPadding, bottom: minimumPadding),
          children: <Widget>[
            DrawerHeader(
              child: Text("User Mangment"),
              decoration: BoxDecoration(color: Colors.blue),
            ),
            ListTile(
              title: Text("Register User"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => registerUser()));
              },
            ),
            ListTile(
              title: Text("Get Users"),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => getusers()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
