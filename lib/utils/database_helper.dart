import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:savoria_test/modules/soal_dua/model/market_model.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get databaseMarket async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "db_market.db");

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE market(
      market_kode TEXT PRIMARY KEY,
      market_name TEXT,
      market_address TEXT,
      latitude_longitude TEXT,
      photo TEXT,
      photo_path TEXT,
      created_date TEXT,
      updated_date TEXT
    )
    ''');
  }

  // save data market
  Future<void> insertMarket(MarketModel data) async {
    final db = await databaseMarket;
    List<MarketModel> marketList = await getListMarket();
    int increment = marketList.length + 1;
    String currentDate = DateFormat('ddMMyy').format(DateTime.now());
    String newMarketKode = "MARKET_${currentDate}_${increment.toString().padLeft(4, '0')}";
    data.marketKode = newMarketKode;
    await db.insert('market', data.toMap());
  }

  // update data market
  Future<void> updateMarket(MarketModel data, String marketKode) async {
    final db = await databaseMarket;
    await db.update('market', data.toMap(), where: 'market_kode = ?', whereArgs: [marketKode]);
  }

  // delete data market
  Future<bool> deleteMarket(String marketKode) async {
    final db = await databaseMarket;
    int result = await db.delete('market',where: 'market_kode = ?', whereArgs: [marketKode]);

    return result > 0;
  }

  // list data market
  Future<List<MarketModel>> getListMarket() async {
    Database db = await databaseMarket;
    List<Map<String,dynamic>> maps = await db.query('market');
    return List.generate(maps.length, (i){
      return MarketModel.fromMap(maps[i]);
    });
  }

  // get detail data market
  Future<MarketModel?> getDetailMarket(String marketKode) async {
    Database db = await databaseMarket;
    final result = await db.query(
      'market',
      where: 'market_kode = ?',
      whereArgs: [marketKode],
    );

    if(result.isNotEmpty){
      return MarketModel.fromMap(result.first);
    }else{
      return null;
    }
  }

}