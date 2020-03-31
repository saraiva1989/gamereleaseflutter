
import 'BancoDados.dart';

class FavoritosDB {
    final dbHelper = BancoDados.instance;
  
  void inserir(idExterno, conteudoJson) async {
    // row to insert
    Map<String, dynamic> row = {
      BancoDados.columnIdExterno : idExterno,
      BancoDados.columnConteudoJson  : conteudoJson
    };
    final id = await dbHelper.insert(row);
    print('inserted row id: $id');
  }

  Future<List<Map<String, dynamic>>> consultar() async {
    final allRows = await dbHelper.queryAllRows();
    print('query all rows:');
    return allRows;
    //allRows.forEach((row) => print(row));
  }

  Future<Map<String, dynamic>> consultarId(idExterno) async {
    return await dbHelper.queryById(idExterno);
  }

  void atualizar(id, idExterno, conteudoJson) async {
    // row to update
    Map<String, dynamic> row = {
      BancoDados.columnId   : id,
      BancoDados.columnIdExterno : idExterno,
      BancoDados.columnConteudoJson  : conteudoJson
    };
    final rowsAffected = await dbHelper.update(row);
    print('updated $rowsAffected row(s)');
  }

  void deletar(idExterno) async {
    // Assuming that the number of rows is the id for the last row.
    await dbHelper.delete(idExterno);

  }

  void deletarbanco() async {
    await dbHelper.deleteDatabase();
  }
}