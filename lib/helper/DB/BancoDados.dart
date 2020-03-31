import 'dart:io';

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class BancoDados {
  
  static final _databaseName = "MyDatabase.db";
  static final _databaseVersion = 2;

  static final table = 'favoritos';
  
  static final columnId = 'Id';
  static final columnIdExterno = 'IdExterno';
  static final columnConteudoJson = 'conteudoJson';

// faz disso uma classe singleton
  BancoDados._privateConstructor();
  static final BancoDados instance = BancoDados._privateConstructor();

// possui apenas uma única referência em todo o aplicativo ao banco de dados
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
// instanciar preguiçosamente o banco de dados na primeira vez que ele é acessado
    _database = await _initDatabase();
    return _database;
  }
  
// isso abre o banco de dados (e cria se não existir)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  Future<void> deleteDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    databaseFactory.deleteDatabase(path);
  }

  // código SQL para criar a tabela do banco de dados
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnIdExterno INTEGER NOT NULL,
            $columnConteudoJson TEXT NOT NULL
          )
          ''');
  }
  
// Métodos auxiliares

// Insere uma linha no banco de dados em que cada chave no mapa é um nome de coluna
// e o valor é o valor da coluna. O valor de retorno é o ID do
// linha inserida.
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(table, row);
  }

// Todas as linhas são retornadas como uma lista de mapas, onde cada mapa é
// uma lista de colunas com valores-chave.
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

// Todos os métodos (inserção, consulta, atualização, exclusão) também podem ser feitos usando
// comandos SQL brutos. Este método usa uma consulta bruta para fornecer a contagem de linhas.
  Future<int> queryRowCount() async {
    Database db = await instance.database;
    return Sqflite.firstIntValue(await db.rawQuery('SELECT COUNT(*) FROM $table'));
  }

  Future<Map<String, dynamic>> queryById(id) async {
    Database db = await instance.database;
    Map<String, dynamic> retorno = Map<String, dynamic>();
    var lista = await db.query(table, where: 'IdExterno = ?', whereArgs: [id]);
    if (lista.length > 0){
      retorno = lista.first;
    }
    return retorno;
  }

  // Estamos assumindo aqui que a coluna id no mapa está definida. O outro
  // valores da coluna serão usados para atualizar a linha.
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnId];
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

// Exclui a linha especificada pelo ID. O número de linhas afetadas é
// devolvida. Deve ser 1, desde que a linha exista.
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return await db.delete(table, where: '$columnIdExterno = ?', whereArgs: [id]);
  }
}
