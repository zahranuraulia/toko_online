import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:toko_online/models/cart.dart';
import 'dart:io' as io;

class DBHelper {
  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database!;
    _database = await initDatabase();
    return _database;
  }

  initDatabase() async {
    if (io.Platform.isWindows || io.Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }
    io.Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, 'cart.db');
    return await openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE IF NOT EXISTS cart(id INTEGER PRIMARY KEY, nama_barang TEXT, deskripsi TEXT, stok INTEGER, harga DOUBLE, quantity INTEGER, image TEXT)'
      );
    });
  }

  Future<Cart> insert(Cart cart) async {
    var dbClient = await database;
    await dbClient!.insert('cart', cart.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    return cart;
  }

  Future<List<Cart>> getCartList() async {
    var dbClient = await database;
    final List<Map<String, Object?>> queryResult = await dbClient!.query('cart');
    return queryResult.map((result) => Cart.fromMap(result)).toList();
  }

  Future<List<Cart>> getCartListDetail(int id) async {
    var dbClient = await database;
    final queryResult = await dbClient!.query('cart', where: 'id = ?', whereArgs: [id]);
    return queryResult.map((result) => Cart.fromMap(result)).toList();
  }

  Future<int> updateQuantity(int id, int qty) async {
    var dbClient = await database;
    return await dbClient!.update('cart', {"quantity": qty}, where: "id = ?", whereArgs: [id]);
  }

  Future<int> deleteCartItem(int id) async {
    var dbClient = await database;
    return await dbClient!.delete('cart', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> clearCart() async {
    var dbClient = await database;
    return await dbClient!.delete('cart');
  }
}