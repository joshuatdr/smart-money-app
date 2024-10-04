import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/testapi.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
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
  final nickNameController = TextEditingController();
  final emailController = TextEditingController();
  final passController = TextEditingController();
  final incomeController = TextEditingController();
  final savingsController = TextEditingController();
  var dark = false;
  List<String> str = [
    'A password must be at least 8 characters long.',
    'Must contain an uppercase',
    'lowercase letter',
    'A number',
    'A special character'
  ];

  @override
  Widget build(BuildContext context) {
    AsyncSnapshot.waiting();
    var userId = context.watch<UserProvider>().userID;
    String? validatePass(String? value) {
      const patternPass =
          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
      final regex = RegExp(patternPass);

      if (value!.isEmpty) {
        return 'A password must be at least 8 characters long.'
            ' must contain an uppercase'
            'lowercase letter'
            'A number'
            'A special character';
      } else {
        return value.isNotEmpty && !regex.hasMatch(value)
            ? 'A password must be at least 8 characters long, must contain an uppercase, lowercase letter, a number and a special character'
            : null;
      }
    }

    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern);

      if (value!.isEmpty) {
        return 'Enter a valid email address';
      } else {
        return value.isNotEmpty && !regex.hasMatch(value)
            ? 'Enter a valid email address'
            : null;
      }
    }

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
                  Text("Edit Profile",
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
                        controller: nickNameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: "Name",
                        ),
                      ),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                          keyboardType: TextInputType.numberWithOptions(),
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: "Email",
                          ),
                          validator: emailController.text.isNotEmpty
                              ? validateEmail
                              : null),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: "Password",
                          ),
                          validator: passController.text.isNotEmpty
                              ? validatePass
                              : null),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                        controller: incomeController,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          labelText: "Income",
                        ),
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      TextFormField(
                        controller: savingsController,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
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
                                onPressed: () async {
                                  updateUser(
                                      userId,
                                      nickNameController.text,
                                      emailController.text,
                                      passController.text,
                                      incomeController.text,
                                      savingsController.text);
                                },
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
              ), //
            ],
          ),
        ),
      ),
    );
  }
}
