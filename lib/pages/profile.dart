import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/edit_profile.dart';
import '../model/user.dart';
import '../services/api.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});
  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isReadOnly = true;
  // final userId = context.watch<UserProvider>().userID;
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
          title: const Text('Account deletion'),
          content: const Text('Remember this is an irreversible action'),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // closes prompt
              },
            ),
            TextButton(
              child: const Text('Next'),
              onPressed: () {
                Navigator.of(context).pop(); // closes prompt
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text('Confirm Account Deletion'),
                      content: const Text(
                          'Please confirm if you would like to delete your account.'),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('No! I want my account'),
                          onPressed: () {
                            Navigator.of(context).pop(); // closes prompt
                          },
                        ),
                        TextButton(
                          child: const Text('Yes! Get rid of it!'),
                          onPressed: () {
                            Navigator.of(context).pop(); // closes prompt
                            // deleteUser(userId);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.orange,
            title: Center(
                child: Text("Profile", style: TextStyle(color: Colors.white))),
          )),
      body: FutureBuilder(
          future: UserServices()
              .getAllUserData(context.watch<UserProvider>().userID),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Error fetching user data"),
              );
            }

            if (snapshot.hasData) {
              //var data = snapshot .data;
              var data = snapshot.data as List<User>;
              print(data);

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
                            child: TextFormField(
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: "Password",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              initialValue: "${data[index].password}",
                              readOnly: isReadOnly,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Income",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              initialValue: "£${data[index].income}",
                              readOnly: isReadOnly,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              decoration: InputDecoration(
                                labelText: "Savings target",
                                enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      const BorderSide(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              initialValue: "£${data[index].savingsTarget}",
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
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditProfile()),
                                  );
                                },
                                child: Text("Edit")),
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
                                        foreground: Paint()
                                          ..color = Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),

                                onPressed: () {
                                  promptUser(context);
                                }, // call the prompt
                                child: Text("DELETE ACCOUNT",
                                    style: TextStyle(color: Colors.white)),
                              ))
                        ],
                      ),
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
