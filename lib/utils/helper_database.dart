
import 'dart:async';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqfdatabase/models/user.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class HelperDatabase{
  final String _TABLE_NAME = "user";
  final String _USER_ID_COLUMN = "id";
  final String _USER_NAME_COLUMN = "name";
  final String _USER_ADDRESS_COLUMN = "address";
  static final HelperDatabase _instance = new HelperDatabase.internal();

  //  factory constructor
  factory HelperDatabase() => _instance;

  HelperDatabase.internal();

  static Database _db;

  Future<Database> get db async {
    if(_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  //  creating database here
  initDb() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "my_db.db");

   var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  //  create table
  FutureOr<void> _onCreate(Database db, int version) async {
    String sql = "CREATE TABLE $_TABLE_NAME($_USER_ID_COLUMN INTEGER PRIMARY KEY, $_USER_NAME_COLUMN TEXT, $_USER_ADDRESS_COLUMN TEXT);";
    await db.execute(sql);
  }

  //  add user
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int result = await dbClient.insert("$_TABLE_NAME", user.toMap());
    return result;
  }

  //  get all user
  Future<List> getAllUser() async {
    String sql = "SELECT * FROM $_TABLE_NAME;";
    var dbClient = await db;
    var result = await dbClient.rawQuery(sql);
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
      await dbClient.rawQuery("SELECT COUNT(*) FROM $_TABLE_NAME")
    );
  }

  Future<User> getUser(int id) async {
    var dbClient = await db;
    
    var result = await dbClient.rawQuery("SELECT * FROM $_TABLE_NAME WHERE $_USER_ID_COLUMN=$id;");
    if(result.length == 0) return null;
    
    return new User.fromMap(result.first);
  }
  
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    
    return await dbClient.delete(_TABLE_NAME, where: "$_USER_ID_COLUMN=?", whereArgs: [id]);
  }

  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(_TABLE_NAME,
        user.toMap(), where: "$_USER_ID_COLUMN=?", whereArgs: [user.id]);
  }

  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }

}