import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DB {
  /// Contrutor com acesso privado
  DB._();

  /// Criar uma instância de DB
  static final DB instance = DB._();

  /// Instância do SQLite
  static Database? _database;

  get database async {
    if (_database != null) return _database;
    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(join(await getDatabasesPath(), 'cripto.db'), version: 2, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    await db.execute(_conta);
    await db.execute(_carteira);
    await db.execute(_historico);
    await db.execute(_moeda);
    await db.insert("conta", {"saldo": 0});
  }

  String get _conta => ''' 
  
  CREATE TABLE conta (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  saldo REAL 
  );
  
  ''';

  String get _carteira => ''' 
  
  CREATE TABLE carteira (
  sigla TEXT PRIMARY KEY,
  moeda TEXT,
  quantidade TEXT 
  );
  
  ''';

  String get _historico => ''' 
  
  CREATE TABLE historico (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  data_operacao INT,
  tipo_operacao TEXT,
  moeda TEXT,
  sigla TEXT,
  valor REAL,
  quantidade TEXT
  );
  
  ''';

  String get _moeda => '''
  
  CREATE TABLE moeda (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  nome TEXT,
  sigla TEXT,
  icone TEXT,
  preco REAL,
  dolar_preco REAL,
  favorito INT
  );
  ''';
}
