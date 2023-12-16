



import 'package:dio/dio.dart';

import 'dataExceptions.dart';

class GenericException implements Exception {
  final String message;

  GenericException(this.message);
}

class AppException implements Exception {
  final Object error;
  final ErrorType type;
  final int? statusCode;

  AppException({required this.error, required this.type, this.statusCode});
}
enum ErrorType {
  dioError,
  firebaseError,
  appError,
}

String errorHandler(AppException appException) {
  var errorMsg = '';
  if (appException.error is String) {
    //Something went wrong error
    errorMsg = appException.error as String;
  } else if (appException.type == ErrorType.dioError) {
    //Dio code error
    var dioError = appException.error as DioError;
    errorMsg = DataException.errorResponseHandler(dioError);
  } else {
    //Status code error
    errorMsg = DataException.handleError(appException.statusCode!);
  }
  print('errorMsg:: $errorMsg');
  return errorMsg;
}

