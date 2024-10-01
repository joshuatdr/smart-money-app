import 'package:flutter/material.dart';
import '../model/user.dart';
import '../services/api.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Center(
            child: Text("My profile", style: TextStyle(color: Colors.white))),
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
                        Text(
                          "${data[index].nickName}",
                          style: TextStyle(
                              fontSize: 50, fontWeight: FontWeight.bold),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(40),
                          child: CircleAvatar(
                              //backgroundImage: NetworkImage(data[index].avatar!),
                              radius: 120),
                        ),
                        Text(
                          "Email: ${data[index].email}",
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
