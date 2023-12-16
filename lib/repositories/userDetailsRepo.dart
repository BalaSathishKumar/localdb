
import 'dart:convert';

import 'package:dio/dio.dart';

import '../models/userReponseModel.dart';
import '../utils/generic_exception.dart';

class UserDetailsRepository {
  Dio? _dio;
  List<dynamic> responseData = [];



  Future<List?> GetUserDetailsapi() async {
    Duration millisec = const Duration(milliseconds: 10000);
    _dio = Dio(BaseOptions(connectTimeout: millisec));
  //  _dio!.options.baseUrl = "https://crudcrud.com/api/d1d6ee53088d4bf79df7abe6b5285875";
    _dio!.options.baseUrl = "https://crudcrud.com/api/60017543102f4cd1bff26ee26b71c8be";
    _dio!.interceptors.addAll([]);
   var response = await get("/sathishAbservetech");

   print('TestsubscriptionResponse:: ${response}');
    if (response != null) {
      //Success returning data back
      print('responseRepo:: $response');
      //return userResponseModelFromJson(response.toString());

      List<dynamic> myList = response;
      String jsonString = jsonEncode(myList);

      try {
        responseData = jsonDecode(jsonString);

      return responseData;
      } catch (e) {
        print('Error decoding or processing the response: $e');
      }

    } else {
      //Failed returning null
      print('TestsubscriptionerrorNull:: $response');
      return null;
    }
  }

  Future<dynamic> get(String url) async {
    try {
      Response response;
      response = await _dio!.get(url,);
      final data = response.data;
      print('responseDio:: $data');

      return data;
    } on DioError catch (error) {
      if (error.response != null) {
        print('errorDio:: $error');
        throw AppException(error: error, type: ErrorType.dioError, statusCode: error.response!.statusCode);
      }
    } catch (error, stacktrace) {
      print('errorGetStacktrace:: $stacktrace');
      throw AppException(
        error: error.toString(),
        type: ErrorType.appError,
      );
    }
  }      // this can be make as common function

}

