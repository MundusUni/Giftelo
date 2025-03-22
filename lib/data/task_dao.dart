class TaskDao {
  static const String tableSql ='CREATE TABLE $_tablename('
  '$_nomeDoCliente TEXT,'
  '$_usos INT,'
  '$_usosMax INT,'
  '$_celular INT,'
  '$_layout TEXT)';

static const String _tablename ='TaskTable';
static const String _nomeDoCliente = 'Nome';
static const String _usos = 'Usos';
static const String _usosMax = 'Usos Máximos';
static const String _celular = 'Whatsapp';
static const String _layout = 'Layout';

save(){
  
}

}