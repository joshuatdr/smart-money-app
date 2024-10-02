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
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.orange,
            title: Center(
                child: Text("Profile", style: TextStyle(color: Colors.white))),
            actions: <Widget>[
              Row(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 59, 17, 107),
                    ),
                    onPressed: () {
                      setState(() {
                        isReadOnly = false;
                      });
                    },
                    child: Text("Edit", style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ],
          )),
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
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(40),
                            child: CircleAvatar(
                                backgroundImage:
                                    NetworkImage(data[index].avatar_url!),
                                radius: 120),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Name",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              initialValue: "${data[index].nickName}",
                              readOnly: isReadOnly,
                              style: TextStyle(
                                  fontSize: 30, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Email",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              initialValue: "${data[index].email}",
                              readOnly: isReadOnly,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: OutlinedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    textStyle: TextStyle(
                                        foreground: Paint()
                                          ..color = Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  setState(() {
                                    isReadOnly = true;
                                  });
                                },
                                child: Text("Submit")),
                          ),
                        ],
                      ),
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
