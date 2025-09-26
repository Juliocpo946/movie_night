import 'package:sqflite/sqflite.dart';
import '../../../../core/services/database_helper.dart';
import '../models/user_model.dart';

class AuthLocalDatasource {
  final DatabaseHelper _databaseHelper;

  AuthLocalDatasource(this._databaseHelper);

  Future<void> registerUser(UserModel user) async {
    final db = await _databaseHelper.database;

    try {
      await db.insert(
        'users',
        user.toJson(),
        conflictAlgorithm: ConflictAlgorithm.abort,
      );
    } on DatabaseException catch (e) {
      if (e.isUniqueConstraintError()) {
        throw Exception('El email ya está registrado');
      }
      throw Exception('Error al registrar usuario: ${e.toString()}');
    }
  }

  Future<UserModel?> findUserByEmailAndPassword(String email, String password) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ? AND password = ?',
      whereArgs: [email, password],
    );

    if (result.isEmpty) {
      return null;
    }

    return UserModel.fromJson(result.first);
  }

  Future<bool> emailExists(String email) async {
    final db = await _databaseHelper.database;

    final result = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
    );

    return result.isNotEmpty;
  }
}