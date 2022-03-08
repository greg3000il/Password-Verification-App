//This Page Does not have content but is responsible for the Delete user function
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:password_verifications_app/Screens/getUsers.dart';
import 'package:http/http.dart' as http;
import '../Models/userModel.dart';

class deleteUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return deleteUserState();
  }
}

//Here we call the delete function from the backend
Future<UserModel> deleteUsers(String username, String password) async {
  var Url = "http://localhost:8080/removeuser";
  var response = await http.delete(
    Url,
    headers: <String, String>{"Content-Type": "application/json;charset=UTF-8"},
  );
  return UserModel.fromJson(jsonDecode(response.body));
}

class deleteUserState extends State<deleteUser> {
  @override
  Widget build(BuildContext context) {
    return getusers();
  }
}
