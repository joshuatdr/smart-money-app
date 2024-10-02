import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/api.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
 bool isReadOnly = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
            child: Text("My profile", style: TextStyle(color: Colors.white))),
            actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),

            onPressed:(){
              setState(() {
                isReadOnly = !isReadOnly;
            });
}
          ),
        ],
      ),
      body: FutureBuilder(
          future: UserServices().getAllUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error fecthing user data"),
              );
            }

            if (snapshot.hasData) {
              //var data = snapshot .data;
              var data = snapshot.data as List<User>;

              return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        TextFormField(
                          initialValue: "${data[index].nickName}",
                          readOnly:isReadOnly,
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: CircleAvatar(
                              backgroundImage: NetworkImage(data[index].avatar_url!),
                              radius: 120),
                        ),
                        TextFormField(
                          initialValue: "Email: ${data[index].email}",
                          readOnly:isReadOnly,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ],
                    )

                        //

                        ;
                  });
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
