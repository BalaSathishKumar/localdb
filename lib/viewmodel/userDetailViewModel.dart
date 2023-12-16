import 'package:flutter/cupertino.dart';

import '../models/userReponseModel.dart';
import '../repositories/userDetailsRepo.dart';
import '../utils/generic_exception.dart';
import 'base_view_model.dart';

class UserDetailViewModel  extends BaseViewModel{

  final UserDetailsRepository _userDetailsRepository = UserDetailsRepository();
  List<userResonseModel>? _userResonseModel;
  List<userResonseModel> responseData2 = [];
  List<userResonseModel>? get UserResponseModel => _userResonseModel;

  String errorMsg = '';
  Future<List<userResonseModel>?> GetUserDetailsapi({

    required Function(String) onFailureRes,
    required Function(List<userResonseModel>?) onSuccessRes,
  }) async {
    setState(ViewState.busy);
    try {
      var data = await _userDetailsRepository.GetUserDetailsapi();
      if (data != null) {
        //_userResonseModel = data;
        if (data.isNotEmpty) {
          responseData2.clear();
          for (var item in data) {
            print('ID: ${item["_id"]}');
            print('Name: ${item["name"]}');
            if (data != null) {
              responseData2.add(
                  userResonseModel(
                      id: item["_id"],
                      name: item["name"],
                      email:item["email"],
                      mobile: item["mobile"],
                      gender: item["gender"] ));
              print('_userResonseModel ${responseData2.length}');
              setState(ViewState.success);
            }

            return responseData2;
          }


        } else {
          print('Empty response');
          setState(ViewState.idle);
        }


        onSuccessRes(_userResonseModel);
      }else{
        //Failed
        onFailureRes("Something went wrong");
        setState(ViewState.idle);
      }
    } on AppException catch (appException) {
     print('errorType:: ${appException.type}');
     print('onFailure:: $appException');
      //Common Error Handler
      errorMsg = errorHandler(appException);
      //Failed
      onFailureRes(errorMsg);

    }
    return null;
  }
}