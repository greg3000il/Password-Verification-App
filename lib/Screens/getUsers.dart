//This Screen\page is responsible for the output of all the users in the DB
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:password_verifications_app/Models/userModel.dart';
import 'package:password_verifications_app/Screens/deleteUser.dart';
import 'package:password_verifications_app/Screens/userDrawer.dart';
import 'package:http/http.dart' as http;

class getusers extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return getAllUserState();
  }
}

class getAllUserState extends State<getusers> {
  var users = List<UserModel>.generate(200, (index) => null);
  //This Part is Responsible for the backend connection
  Future<List<UserModel>> getUsers() async {
    var data = await http.get('http://localhost:8080/getallusers');
    var jsonData = json.decode(data.body);
    List<UserModel> user = [];
    for (var e in jsonData) {
      UserModel users = new UserModel();
      users.id = e["id"];
      users.username = e["username"];
      users.password = e["password"];
      user.add(users);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text("All user details"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => userDrawer()));
          },
        ),
      ),
      body: Container(
        child: FutureBuilder(
          future: getUsers(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return Container(child: Center(child: Icon(Icons.error)));
            }
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text('ID' + ' ' + 'Username' + ' ' + 'Password'),
                    subtitle: Text('${snapshot.data[index].id}' +
                        " " +
                        '${snapshot.data[index].username}' +
                        " " +
                        '${snapshot.data[index].password}'),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  DetailPage(snapshot.data[index])));
                    },
                  );
                });
          },
        ),
      ),
    );
  }
}
//Here is
class DetailPage extends StatelessWidget {
  UserModel user;
  DetailPage(this.user);
  deleteUser1(UserModel user) async {
    final url = Uri.parse('http://localhost:8080/removeuser');
    final request = http.Request("DELETE", url);
    request.headers
        .addAll(<String, String>{"Content-type": "application/json"});
    request.body = jsonEncode(user);
    final response = await request.send();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(user.username),
        
      ),
      body: Container(
        child: Text('UserName' +
            ' ' +
            user.Username +
            ' ' +
            'Password' +
            user.password),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          deleteUser1(user);
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => deleteUser()));
        },
        child: Icon(Icons.delete),
        backgroundColor: Colors.pink,
      ),
    );
  }
}
