import 'package:cloud_firestore/cloud_firestore.dart';
import 'database_users.dart';

class UserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  final DatabaseUser _localDb = DatabaseUser();
}

  Future<void> addUser(Map<String, dynamic> user) async {
    // 1. Adiciona localmente
    int localId = await _localDb.addUser(user);

    // 2. Adiciona remotamente
    try {
      await usersCollection.doc(localId.toString()).set(user);
    } catch (e) {
      print('Erro ao salvar no Firestore: $e');
    }
  }

  Future<void> updateUser(Map<String, dynamic> user) async {
    await _localDb.updateUser(user);

    try {
      await usersCollection.doc(user['id'].toString()).update(user);
    } catch (e) {
      print('Erro ao atualizar no Firestore: $e');
    }
  }

  Future<void> deleteUser(int id) async {
    await _localDb.deleteUser(id);

    try {
      await usersCollection.doc(id.toString()).delete();
    } catch (e) {
      print('Erro ao deletar do Firestore: $e');
    }
  }

  Future<void> syncFromFirestore() async {
    try {
      final snapshot = await usersCollection.get();
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data();
        data['id'] = int.parse(doc.id); // garante ID igual
        await _localDb.addUser(data); // usa ConflictAlgorithm.replace
      }
    } catch (e) {
      print('Erro ao sincronizar com Firestore: $e');
    }
  }

  Future<void> syncToFirestore() async {
    final localUsers = await _localDb.getAllUsers();
    for (var user in localUsers) {
      try {
        await usersCollection.doc(user['id'].toString()).set(user);
      } catch (e) {
        print('Erro ao enviar usuário ${user['id']} para o Firestore: $e');
      }
    }
  }