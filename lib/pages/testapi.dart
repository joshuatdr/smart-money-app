import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/api.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Data"),
        actions: [
          IconButton(
              onPressed: () {
                print(UserServices().getAllUserData());
              },
              icon: Icon(Icons.refresh))
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
                    return ListTile(
                      leading: CircleAvatar(
                          //backgroundImage: NetworkImage(data[index].avatar!),
                          ),
                      title:
                          Text("${data[index].email} ${data[index].password}"),
                      subtitle: Text("${data[index].nickName}"),
                    );
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
