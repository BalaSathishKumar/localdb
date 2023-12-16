import 'package:flutter/material.dart';

import '../models/userReponseModel.dart';


class CreateUserWidget extends StatefulWidget {

  final userResonseModel? user;
  final ValueChanged<userResonseModel?> onSubmit;

  CreateUserWidget({
    required this.user,
    required this.onSubmit,
});

  @override
  State<CreateUserWidget> createState() => _CreateUserWidgetState();
}

class _CreateUserWidgetState extends State<CreateUserWidget> {

  final controller = TextEditingController();
  final formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    controller.text = widget.user?.name ?? "";
  }
  @override
  Widget build(BuildContext context) {
    final isEditing = widget.user != null;
    return AlertDialog(
      title: Text('Add User'),
      content: Form(
        key: formkey,
        child: TextFormField(
          autofocus: true,
          controller: controller,
          decoration: InputDecoration(hintText: "Title"),
          validator: (value) =>
          value != null && value.isEmpty ? "Title is required" : null,
          onChanged: (value) =>{

          },
        ),
      ),
      actions: [
        TextButton(
            onPressed: (){
          Navigator.pop(context);
          }, child: Text("Cancel")),
        TextButton(
            onPressed: (){
          if(formkey.currentState!.validate()){
            if(widget.user != null && widget.user == controller.text){
              widget.onSubmit(widget.user);
            }else{
              widget.onSubmit(userResonseModel(id: 2, name: controller.text, email: "test@email.com", mobile: "2222222222", gender: "male"));
            }

          }
            }, child: Text("Ok")),
      ],
    );
  }
}
