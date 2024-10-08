import 'package:flutter/material.dart';
import 'package:smart_money_app/model/user.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/pages/auth/login.dart';
import 'package:http/http.dart' as http;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isReadOnly = true;
  Future<void> deleteUser(int userId) async {
    final response = await http.delete(
        Uri.parse("https://smart-money-backend.onrender.com/api/user/$userId"));

    if (response.statusCode == 204) {
      // If the server returns a 204 response, user is successfully deleted
    }
  }

  void promptUser(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            title: Center(
                child: Text(
              'Account Deletion',
              style: TextStyle(
                  color: Colors.lightBlue.shade600,
                  fontWeight: FontWeight.w800,
                  fontSize: 20),
            )),
            content: Text(
                'Please confirm if you would like to delete your account.'),
            actions: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop(); // closes prompt
                    },
                  ),
                  TextButton(
                    child: Text('Next'),
                    onPressed: () {
                      Navigator.of(context).pop(); // closes prompt
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          final userID = context.watch<UserProvider>().userID;
                          return AlertDialog(
                            title: Center(
                                child: Text(
                              'Account Deletion',
                              style: TextStyle(
                                  color: Colors.lightBlue.shade600,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 20),
                            )),
                            content:
                                Text('Remember this is an irreversible action'),
                            actions: <Widget>[
                              Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pop(); // closes prompt
                                      },
                                    ),
                                    TextButton(
                                      child: Text(
                                        'Yes! Delete it!',
                                        style: TextStyle(
                                          color: Colors.red,
                                        ),
                                      ),
                                      onPressed: () {
                                        deleteUser(userID);
                                        context
                                            .read<UserProvider>()
                                            .logoutUser();
                                        Navigator.of(context).pushAndRemoveUntil(
                                            MaterialPageRoute(
                                                builder: (ctx) =>
                                                    LoginScreen()),
                                            (route) =>
                                                false); // route to login page, prevent browser back button
                                      },
                                    )
                                  ]),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ],
              )
            ]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.lightBlue.shade900,
            title: Text("Profile", style: TextStyle(color: Colors.white)),
          )),
      body: FutureBuilder(
        future:
            UserServices().getAllUserData(context.watch<UserProvider>().userID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Error fetching user data"),
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
                            backgroundImage: AssetImage('user.jpg'),
                            radius: 120),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: TextEditingController()
                            ..text = '${data[index].nickName}',
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Name",
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          readOnly: isReadOnly,
                          ignorePointers: true,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: TextEditingController()
                            ..text = '${data[index].email}',
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Email",
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          readOnly: isReadOnly,
                          ignorePointers: true,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: TextEditingController()
                            ..text = '£${data[index].income}',
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Income (per month, after tax)",
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          ignorePointers: true,
                          readOnly: isReadOnly,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: TextEditingController()
                            ..text = '£${data[index].savingsTarget}',
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Savings target (per month)",
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          readOnly: isReadOnly,
                          ignorePointers: true,
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue.shade900,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                                textStyle: TextStyle(
                                    foreground: Paint()..color = Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/editprofile')
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Text("Edit")), 
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: OutlinedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.lightBlue.shade900,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 50, vertical: 20),
                                textStyle: TextStyle(
                                    foreground: Paint()..color = Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            onPressed: () {
                              Navigator.pushNamed(context, '/changepass')
                                  .then((value) {
                                setState(() {});
                              });
                            },
                            child: Text("Change Password")),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: OutlinedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 180, 11, 11),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 50, vertical: 20),
                              textStyle: TextStyle(
                                  foreground: Paint()..color = Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold)),

                          onPressed: () {
                            promptUser(context);
                          }, // call the prompt
                          child: Text("DELETE ACCOUNT",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
