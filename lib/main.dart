

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sqfdatabase/models/user.dart';
import 'package:sqfdatabase/utils/helper_database.dart';

List _users;
var db;
void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  db = new HelperDatabase();
  //  add user
  int savedUser = await db.saveUser(new User("Ketty", "NYC, USA"));
  print("User saved: $savedUser");


  _users = await db.getAllUser();
//  for(int i=0; i<_users.length; i++){
//    User user = User.map(_users[i]);
//    print("User name: ${user.userName}");
//  }

  // user one
  User oneUser = await db.getUser(1);
//  print(oneUser.userName);

//  int delUser = await db.deleteUser(4);
//  print("Delete user: ${delUser}");



  runApp(new MaterialApp(
    title: "SQFLite database",
    home: new Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _nameTextController = new TextEditingController();
  TextEditingController _addressTextController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.pinkAccent,
        title: new Text("sqflite Database"),
        centerTitle: true,
      ),

      body: new Center(
        child: new ListView.builder(
            itemCount: _users.length,
            itemBuilder: (BuildContext context, int position){
              return new Card(
                color: Colors.greenAccent.shade100,
                elevation: 2.0,
                child: new ListTile(

                  leading: new CircleAvatar(
                    child: new Text("${User.fromMap(_users[position]).id}"),
                  ),

                  title: new Text("name: ${User.fromMap(_users[position]).userName}"),
                  subtitle: new Text("address: ${User.fromMap(_users[position]).userAddress}"),



                  onTap: (){
                    debugPrint("name: ${User.fromMap(_users[position]).userName}");
                  },
                ),
              );
            }),
      ),

      floatingActionButton: new FloatingActionButton(
          backgroundColor: Colors.blueGrey,
          child: new Icon(Icons.add, color: Colors.greenAccent,),
          onPressed: () async {
            await db.savedUser(new User("Adam", "Massachussets, USA"));
          }),
    );
  }
}
