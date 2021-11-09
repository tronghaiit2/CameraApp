import 'dart:io';
import 'dart:async';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'cap_img.dart';

class DBProvider {
  static final DBProvider dbase = DBProvider();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    print("initDB");
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "CapImgDB.db");
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      print("init");
      await db
          .execute('CREATE TABLE IMAGES(id INTEGER PRIMARY KEY, path TEXT)');
    });
  }

  Future<List<CapImg>> getAllCapImgs() async {
    print("getAllCapImgs");
    final db = await database;
    var res = await db.query("IMAGES", orderBy: "id DESC");
    List<CapImg> list =
        res.isNotEmpty ? res.map((c) => CapImg.fromJson(c)).toList() : [];
    return list;
  }

  Future<CapImg> getInfoCapImg(String image) async {
    print("getInfoCapImg");
    final db = await database;
    var res = await db.query("IMAGES", where: "path = ?", whereArgs: [image]);
    //print("${CapImg.fromJson(res.first).id}");
    return res.isNotEmpty ? CapImg.fromJson(res.first) : null;
  }

  deleteCapImg(int id) async {
    print("deleteCapImg");
    final db = await database;
    return db.delete("IMAGES", where: "id = ?", whereArgs: [id]);
  }

  updateCapImg(CapImg newImage) async {
    final db = await database;
    var res = await db.update("IMAGES", newImage.toJson(),
        where: "id = ?", whereArgs: [newImage.id]);
    return res;
  }

  newCapImg(CapImg newCapImg) async {
    final db = await database;
    print("add db");
    var raw = await db.rawInsert("INSERT into IMAGES (path)"
        ' VALUES ("${newCapImg.path}")');
    return raw;
  }

  insertCapImg(CapImg image) async {
    final db = await database;
    print("add");
    image.id = await db.insert("IMAGES", image.toJson());
    print("${image.id}");
    print("${image.path}");
  }

  deleteAll() async {
    final db = await database;
    db.rawDelete("DELETE FROM IMAGES");
  }
}
