import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:test/data/task_dao.dart';

Future<Database> getDatabase() async{ //Responsável por procurar o caminho onde o arquivo foi salvo, e abrir o nosso arquivo (que é o banco de dados). Caso este nosso banco de dados não exista ele vai criar o que está no TaskDao.
  final String path = join(await getDatabasesPath(),'task.db');
  return openDatabase(path,onCreate: (db,version){
    db.execute(TaskDao.tableSql);
    }, version:1,);
}

save(){
  
}

//Ações implementadas no DAO: 