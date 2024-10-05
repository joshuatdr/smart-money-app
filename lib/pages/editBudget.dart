import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/profile.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class EditBudgetPage extends StatefulWidget {
  @override
  State<EditBudgetPage> createState() => _EditBudgetPageState();
}

class _EditBudgetPageState extends State<EditBudgetPage> {
  Future<void> updateUser(
    int userId,
    String fname,
    String email,
    String password,
    String income,
    String savingsTarget,
  ) async {
    final response = await http.patch(
      Uri.parse("https://smart-money-backend.onrender.com/api/user/$userId"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: jsonEncode(<String, dynamic>{
        "email": email,
        "password": password,
        "fname": fname,
        "income": income,
        "savings_target": savingsTarget
      }),
    );
    if (response.statusCode == 201) {
      print(userId.runtimeType);
      // If the server returns a 200 OK response, then the user was successfully updated.
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("User Updated"),
            content: Text("user updated successfully."),
            actions: [
              MaterialButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      print(userId.runtimeType);
      // If the server did not return a 201 OK response,
      // then throw an exception.
      throw Exception("Failed to update user");
    }
  }

  bool isChecked = false;
  final _formfield = GlobalKey<FormState>();
  final unavoidableController = TextEditingController();
  final disposeController = TextEditingController();
  final saveController = TextEditingController();

  var dark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: JSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 10, bottom: 50),
                    child: Image(
                      image: AssetImage(dark ? JImages.flag : JImages.flag),
                    ),
                  ),
                  Text("What is your weekly spending amount?",
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(
                    height: JSizes.sm,
                  ),
                ],
              ),

              /// Form
              Form(
                key: _formfield,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: JSizes.spaceBtwItems),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: unavoidableController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.money_off),
                          labelText: "Unavoidable expenses",
                        ),
                      ),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: disposeController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.money_outlined),
                          labelText: "Disposable income",
                        ),
                      ),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                        controller: saveController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.savings),
                          labelText: "Savings target",
                        ),
                      ),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// sign in button
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    textStyle: TextStyle(
                                        foreground: Paint()
                                          ..color = Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {},
                                child: Text("Submit changes"))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => UserScreen()),
                                  );
                                },
                                child: const Text("Back to Profile")),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //
            ],
          ),
        ),
      ),
    );
  }
}
