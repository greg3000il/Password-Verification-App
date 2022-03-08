//This Page is Responsible for the Register Screen
import 'dart:async';
import 'dart:convert';
import 'package:password_verifications_app/Models/userModel.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:password_verifications_app/Screens/userDrawer.dart';

class registerUser extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return registerUserState();
  }
}

//This Function is reponsible for the backend connection
Future<UserModel>registerUsers(
String username,String password,BuildContext context
)async{
  var url = "http://localhost:8080/adduser";
  var response = await http.post(url,
  headers: <String, String>{"Content-Type":"application/json"},
  body: jsonEncode(<String , String>{
    "username": username,
    "password": password
  })
  );
  String responseString = response.body;
  if(response.statusCode==200){
    showDialog(context: context,
    barrierDismissible: true,
    builder :(BuildContext dialogContext){
      return MyAlertDialog(title:'Backend Response',content:response.body);
    },
    );
  }
}

class registerUserState extends State<registerUser> {
  void _iconButton() {
    print("Icon button pressed");
  }

  UserModel user;
  TextEditingController password1 = TextEditingController();
  TextEditingController username=TextEditingController();
  bool _isVisible = false;
  bool _isPasswordLen = false;
  bool _isOneUpChar = false;
  bool _isOneLowChar = false;
  bool _isOneNum = false;
  bool _allValid = false;
  bool _matchPass = false;
  bool _buttonActive = false;
  //This function is responsible to check if the password is up to par with the needed criteria
  onPasswordChanged(String password) {
    final numericRegex = RegExp(r'[0-9]');
    final upCharRegex = RegExp(r'[A-Z]');
    final lowCharRegex = RegExp(r'[a-z]');
    setState(() {
      if (password.length >= 6)
        _isPasswordLen = true;
      else
        _isPasswordLen = false;
      if (numericRegex.hasMatch(password))
        _isOneNum = true;
      else
        _isOneNum = false;
      if (lowCharRegex.hasMatch(password))
        _isOneLowChar = true;
      else
        _isOneLowChar = false;
      if (upCharRegex.hasMatch(password))
        _isOneUpChar = true;
      else
        _isOneUpChar = false;
      if ((_isOneLowChar && _isOneNum) && (_isOneUpChar && _isPasswordLen))
        _allValid = true;
      else
        _allValid = false;
    });
  }
//This function is responsible to compare the two strings 
  passwordMatch(String password, String password2) {
    setState(() {
      if (!password.isEmpty && !password2.isEmpty) {
        if (password == password2) {
          if (_allValid)
            _buttonActive = true;
          else
            _buttonActive = false;
          _matchPass = true;
        } else
          _matchPass = false;
      }
    });
  }

  final minimumPadding = 5.0;
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.subtitle2;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          tooltip: 'Home',
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => userDrawer()));
          },
        ),
        elevation: 0,
        backgroundColor: Colors.blue,
        title: Text(
          "Password Validation",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: <Widget>[
            Text(
              "Create a user",
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Please Create a secure password and a Usernam including the following criterria below.",
              style: TextStyle(
                  fontSize: 18, height: 1.5, color: Colors.grey.shade600),
            ),
            TextField(
              controller: username,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                hintText: "Please Enter your desired username",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(height: 10,),
            TextField(
              onChanged: (password) {
                onPasswordChanged(password);
                password1.text = password;
              },
              obscureText: !_isVisible,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  //this one is responsible for the Visible button (If you can see your password or not)
                  onPressed: () {
                    setState(() {
                      _isVisible = !_isVisible;
                    });
                  },
                  icon: _isVisible
                      ? Icon(Icons.visibility, color: Colors.black)
                      : Icon(
                          Icons.visibility_off,
                          color: Colors.grey,
                        ),
                ),
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                hintText: "Password",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextField(
              onChanged: (password2) {
                passwordMatch(password1.text, password2);
              },
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black)),
                hintText: "Please Type Password Again",
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(microseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _isPasswordLen ? Colors.green : Colors.red,
                      border: _isPasswordLen
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Icon(
                      _isPasswordLen ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                _isPasswordLen
                    ? Text(
                        "Contains more then 6 characters",
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        "Contains more then 6 characters",
                        style: TextStyle(color: Colors.red),
                      )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(microseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _isOneNum ? Colors.green : Colors.red,
                      border: _isOneNum
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Icon(
                      _isOneNum ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                _isOneNum
                    ? Text(
                        "Must Have at least one number 0-9",
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        "Must Have at least one number 0-9",
                        style: TextStyle(color: Colors.red),
                      )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(microseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _isOneUpChar ? Colors.green : Colors.red,
                      border: _isOneUpChar
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Icon(
                      _isOneUpChar ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                _isOneUpChar
                    ? Text(
                        "must contain at least one capital case letter a-z",
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        "must contain at least one capital case letter a-z",
                        style: TextStyle(color: Colors.red),
                      )
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(microseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _isOneLowChar ? Colors.green : Colors.red,
                      border: _isOneLowChar
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Icon(
                      _isOneLowChar ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                _isOneLowChar
                    ? Text(
                        "must contain at least on lower case letter a-z",
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        "must contain at least on lower case letter a-z",
                        style: TextStyle(color: Colors.red),
                      ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                AnimatedContainer(
                  duration: Duration(microseconds: 500),
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                      color: _matchPass ? Colors.green : Colors.red,
                      border: _matchPass
                          ? Border.all(color: Colors.transparent)
                          : Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(50)),
                  child: Center(
                    child: Icon(
                      _matchPass ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 15,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                _matchPass
                    ? Text(
                        "Both Passwords must match",
                        style: TextStyle(color: Colors.green),
                      )
                    : Text(
                        "Both Passwords must match",
                        style: TextStyle(color: Colors.red),
                      ),
              ],
            ),
            MaterialButton(
              height: 40,
              minWidth: double.infinity,
              onPressed: _buttonActive ? () async {
                String username1=username.text;
                String password=password1.text;
                UserModel users=
                  await registerUsers(username1,password,context);
                username.text="";
                password1.text="";
                setState(() {
                  user=users;
                });
              } : null,
              color: _buttonActive ? Colors.black : Colors.grey,
              child: _buttonActive
                  ? Text(
                      "Create Account",
                      style: TextStyle(color: Colors.white),
                    )
                  : Text(
                      "Conditons not met",
                      style: TextStyle(color: Colors.black),
                    ),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5)),
            )
          ],
        ),
      ),
    );
  }

}


class MyAlertDialog extends StatelessWidget{
  final String title;
  final String content;
  final List<Widget> actions;
  MyAlertDialog({
    this.title,
    this.content,
    this.actions=const[],
  });
  @override
  Widget build(BuildContext context){
    return AlertDialog(
      title: Text(
        this.title,
        style: Theme.of(context).textTheme.headline6,
      ),
      actions: this.actions,
      content: Text(
        this.content,
        style: Theme.of(context).textTheme.bodyText2,
      ),
    );
  }
}