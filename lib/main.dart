import 'package:flutter/material.dart';
import 'package:localdatabase/database/user_db.dart';
import 'package:localdatabase/models/userReponseModel.dart';
import 'package:localdatabase/viewmodel/base_view_model.dart';
import 'package:localdatabase/viewmodel/userDetailViewModel.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';

import 'database/create_user_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late BuildContext ctx;

  @override
  Widget build(BuildContext context) {
    ctx = context;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserDetailViewModel>(
            create: (BuildContext ctx) => UserDetailViewModel()),
      ],
      child: MaterialApp(
        title: '',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Api data and Local DB data'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late UserDetailViewModel _userDetailViewModel;
 Future<List<userResonseModel>>? futureUsers;
 final userDB = UserDB();

  @override
  void initState() {
    super.initState();
    _userDetailViewModel = Provider.of<UserDetailViewModel>(context, listen: false);
    fetchUserDB();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _userDetailViewModel.GetUserDetailsapi(onFailureRes: onFailureRes, onSuccessRes: onSuccessRes);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Consumer<UserDetailViewModel>(
      builder: (context,userDetailVM,child){
     return Scaffold(

        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              //userDetailVM.UserResponseModel?.name == null ? CircularProgressIndicator():
               ListView.builder(
                  shrinkWrap: true,
               physics: NeverScrollableScrollPhysics(),
              itemCount: userDetailVM.responseData2.length ?? 0,
               itemBuilder: (context, index) {
                  return userDetailVM.state == ViewState.busy ? CircularProgressIndicator():Card(
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0,vertical: 18),
                      child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              buildApiUser(userDetailVM.responseData2[index].name,"Name"),
                              buildApiUser(userDetailVM.responseData2[index].email,"Email"),
                              buildApiUser(userDetailVM.responseData2[index].mobile,"Mobile"),
                              buildApiUser(userDetailVM.responseData2[index].gender,"Gender"),

                              SizedBox(height: 18),
                              Text("Note: These are api data. you can add these or you can edit name before saving in db, please check below list to see latest saved data."),
                              Center(
                                  child: MaterialButton(
                                    onPressed:(){
                                showDialog(context: context, builder: (_) => CreateUserWidget(
                                  user: userDetailVM.responseData2[index],
                                  onSubmit: (title) async {
                                    if(title != null){
                                      await userDB.create(usermodel: title);
                                      if(!mounted) return;
                                      fetchUserDB();
                                      Navigator.pop(context);
                                    }
                                    },
                                ));
                              },
                                child: Text("Add to db",style: TextStyle(color: Colors.white),),
                                height: 30,
                                color: Colors.blue, ))
                            ],
                          )),
                    ),
                  ); }),

              Container(

                child: Column(
                  children: [
                    SizedBox(height: 18),
                    Text("These are Sql data."),
                    FutureBuilder<List<userResonseModel>>(
                      future: futureUsers,
                        builder: (context,snapshot) {
                        if(snapshot.connectionState == ConnectionState.waiting){
                          return Center(child: CircularProgressIndicator());
                        }else {

                          if(snapshot.data != null){
                            final users = snapshot.data!;
                            return users.isEmpty ? Center(child: Text("No Users")) :
                            ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: users.length ?? 0,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(color: Colors.grey, width: 1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      title: Text(users[index].name),
                                      subtitle: Text(users[index].email),
                                    ),
                                  );
                                });
                          }else{
                            return Center(child: Text("No Users"));
                          }
                        }
                        }),
                  ],
                ),
              )


            ],
          ),
        ),

      );
      }
    );
  }

  buildApiUser(String title, content) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
              flex: 1,
              child: Text(
                content,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )),
          Expanded(flex: 1, child: Text(": ${title}")),
        ],
      ),
    );
  }

  onFailureRes(String p1) {
  }

  onSuccessRes(List<userResonseModel>? p1) {
    print('success data ${p1?.length}');



  }

  void fetchUserDB() {
    setState(() {
      futureUsers = userDB.fetchAll();
    });
  }
}
