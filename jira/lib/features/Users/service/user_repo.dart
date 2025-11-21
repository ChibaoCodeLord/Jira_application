import 'package:jira/core/api_client.dart';
import '../model/user_model.dart';

class UserService {
  static Future<UserModel> getUserById(String userId) async {
    try {
      final response = await ApiClient.dio.get('/users/$userId');
      if (response.data['statusCode'] == 200) {
        final userData = response.data['data'];
        return UserModel.fromJson(userData);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load user');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  static Future<List<UserModel>> getUsersInProject(String projectId) async {
    final response = await ApiClient.dio.get('/projects/$projectId/members');
    if (response.statusCode == 200 && response.data['success'] == true) {
      final usersData = response.data['users'] as List<dynamic>;
      return usersData.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}
