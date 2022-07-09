import 'package:dio/dio.dart';
import 'package:edutiv/model/profile/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAPI {
  String baseUrl = 'https://edutiv-capstone.herokuapp.com';

  Future<List<UserModel>> fetchAllUser() async {
    Response response = await Dio().get(baseUrl + '/user');

    if (response.statusCode == 200) {
      List<UserModel> course = (response.data['data'] as List)
          .map((e) => UserModel.fromJson(e))
          .toList();
      return course;
    } else {
      throw Exception('No User Available.');
    }
  }

  Future<UserModel> fetchUserById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    Response response = await Dio().get(
      baseUrl + '/user' + '/$id',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      return UserModel.fromJson(response.data['data']);
    } else {
      throw Exception('User Not Available');
    }
  }

  Future<UserModel> updateProfile(int userId, int specializationId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      var response = await Dio().put(
        baseUrl + '/user' + '/$userId',
        options: Options(
          sendTimeout: 9000,
          receiveTimeout: 9000,
          method: 'put',
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: {
          "specialization_id": specializationId,
        },
      );
      if (response.statusCode == 200) {
        print(response.data);
        return UserModel.fromJson(response.data['data']);
      } else {
        throw Exception('User Not Available');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
