import 'package:dio/dio.dart';
import 'package:edutiv/model/course/course_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/review/review_model.dart';

class CourseAPI {
  String baseUrl = 'https://edutiv-capstone.herokuapp.com';

  Future<List<CourseModel>> fetchAllCourse() async {
    Response response = await Dio().get(baseUrl + '/course');

    if (response.statusCode == 200) {
      List<CourseModel> course = (response.data['data'] as List)
          .map((e) => CourseModel.fromJson(e))
          .toList();
      return course;
    } else {
      throw Exception('No Course Available.');
    }
  }

  Future<CourseModel> fetchCourseById(int id) async {
    Response response = await Dio().get(baseUrl + '/course' + '/$id');

    if (response.statusCode == 200) {
      return CourseModel.fromJson(response.data['data']);
    } else {
      throw Exception('Course Not Available');
    }
  }

  Future enrollCourse(int userId, int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    Response response = await Dio().post(
      baseUrl + '/enrolled',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
      data: {
        "user_id": userId,
        "course_id": courseId,
      },
    );
    return response.data;
  }

  Future<Review> createReview(
      int courseId, int userId, int rating, String review) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    Response response = await Dio().post(
      baseUrl + '/course' + '/$courseId' + '/review',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
      data: {
        "courseId": courseId,
        "user_id": userId,
        "rating": rating,
        "review": review,
      },
    );
    return Review.fromJson(response.data);
  }

  Future searchCourseByName(String query) async {
    Response response = await Dio().get(baseUrl + '/course/search/$query');

    if (response.statusCode == 200) {
      List<CourseModel> course = (response.data['data'] as List)
          .map((e) => CourseModel.fromJson(e))
          .toList();
      return course;
    } else if (response.statusCode == 400) {
      return query = '';
    } else {
      throw Exception('Course Not Available');
    }
  }

  Future<List<Review>> fetchAllReviewFromCourseId(int courseId) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString('token');
    Response response = await Dio().get(
      baseUrl + '/enrolled/courses/$courseId',
      options: Options(
        headers: {'Authorization': 'Bearer $token'},
      ),
    );

    if (response.statusCode == 200) {
      List<Review> allReview = (response.data['data'] as List)
          .map((e) => Review.fromJson(e))
          .toList();
      return allReview;
    } else {
      throw Exception('No Reviews Available');
    }
  }

  // Future<List<Section>> getAllSectionFromCourseId(int id) async {
  //   Response response = await Dio()
  //       .get('https://edutiv-springboot.herokuapp.com/course/$id/section');

  //   if (response.statusCode == 200) {
  //     List<Section> allSection = (response.data['data'] as List)
  //         .map((e) => Section.fromJson(e))
  //         .toList();
  //     return allSection;
  //   } else {
  //     throw Exception('No Section Available');
  //   }
  // }

  // Future<List<Materials>> getAllMaterialsFromSectionId(
  //     int courseId, int sectionId) async {
  //   Response response = await Dio().get(
  //       'https://edutiv-springboot.herokuapp.com/course/$courseId/section/$sectionId/material');

  //   if (response.statusCode == 200) {
  //     List<Materials> allMaterials = (response.data['data'] as List)
  //         .map((e) => Materials.fromJson(e))
  //         .toList();
  //     return allMaterials;
  //   } else {
  //     throw Exception('No Materials Available');
  //   }
  // }

  // Future<List<Tools>> getAllToolsFromCourseId(int courseId) async {
  //   Response response = await Dio()
  //       .get('https://edutiv-springboot.herokuapp.com/course/$courseId/tool');

  //   if (response.statusCode == 200) {
  //     List<Tools> allTools = (response.data['data'] as List)
  //         .map((e) => Tools.fromJson(e))
  //         .toList();
  //     return allTools;
  //   } else {
  //     throw Exception('No Tools Available');
  //   }
  // }

}
