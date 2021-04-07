import 'dart:io' as io;
import 'package:hrm/main/models/user.dart';
import 'package:path/path.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

final String tableUser = 'User';
final String columnId = 'id';
final String columnUsername = 'username';
final String columnPassword = 'password';
final String columnSid = 'sid';



class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database _db;

  Future<Database> get db async {
    if(_db != null)
      return _db;
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "main.db");
    // await deleteDatabase(path);
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  void _onCreate(Database db, int version) async {
    // When creating the db, create the table
    await db.execute(
        "CREATE TABLE User(id INTEGER PRIMARY KEY, username TEXT, password TEXT, sid TEXT)");
    print("Created tables");
  }

  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("User", user.toMap());
    return res;
  }

  Future<int> deleteUsers() async {
    var dbClient = await db;
    int res = await dbClient.delete("User");
    return res;
  }

  Future<bool> isLoggedIn() async {
    var dbClient = await db;
    var res = await dbClient.query("User");
    return res.length > 0? true: false;
  }

  Future<int> insert(User user) async {
    int res = await _db.insert(tableUser, user.toMap());
    return res;
  }

  Future<User> getUser() async {
    List<Map> maps = await _db.query(tableUser, columns: [columnId, columnUsername, columnPassword,columnSid]);
    if (maps.length > 0) {
      return User.map(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await _db.delete(tableUser, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> update(User user , int id) async {
    return await _db.update(tableUser, user.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
  }

  Future close() async => _db.close();

}