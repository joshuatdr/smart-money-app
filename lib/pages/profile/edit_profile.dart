import 'package:flutter/material.dart';
import 'package:smart_money_app/common/styles/spacing_styles.dart';
import 'package:smart_money_app/common/image_strings.dart';
import 'package:smart_money_app/common/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:smart_money_app/providers/user_provider.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Success',
      subtitle: 'Profile Updated',
      configuration: IconConfiguration(
        icon: Icons.check,
        color: Colors.white,
      ),
      backgroundColor: Colors.lightBlue.shade900.withOpacity(.9),
      subtitleOptions: StatusAlertTextConfiguration(
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
      titleOptions: StatusAlertTextConfiguration(
        style: TextStyle(color: Colors.white, fontSize: 24),
      ),
    );
    Navigator.pop(context);
  }

  Future<void> updateUser(data, userID) async {
    final patchBody = jsonEncode(data);
    // print('$patchBody <--- encoded JSON');
    final response = await http.patch(
      Uri.parse("https://smart-money-backend.onrender.com/api/user/$userID"),
      headers: <String, String>{
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: patchBody,
    );
    if (response.statusCode == 201) {
      if (!mounted) return;
      showSuccessAlert(context);
    } else {
      // print('FAIL');
      // If the server did not return a 201 OK response,
      // then throw an exception.
    }
  }

  bool isChecked = false;
  final _formfield = GlobalKey<FormState>();
  final nickNameController = TextEditingController();
  final emailController = TextEditingController();
  // final passController = TextEditingController();
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
    var userID = context.watch<UserProvider>().userID;

    String? validateEmail(String? value) {
      const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
          r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
          r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
          r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
          r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
          r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
          r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
      final regex = RegExp(pattern, caseSensitive: false);

      if (value!.isEmpty) {
        return null;
      } else {
        return value.isNotEmpty && !regex.hasMatch(value)
            ? 'Enter a valid email address'
            : null;
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
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
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.abc),
                          labelText: "Name",
                        ),
                      ),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                        autovalidateMode: AutovalidateMode.always,
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: emailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.email),
                          labelText: "Email",
                        ),
                        validator: validateEmail,
                      ),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                        controller: incomeController,
                        obscureText: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.currency_pound),
                          labelText: "Income",
                        ),
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      TextFormField(
                        controller: savingsController,
                        obscureText: false,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.balance),
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
                                    backgroundColor: Colors.lightBlue.shade900,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 50, vertical: 20),
                                    textStyle: TextStyle(
                                        foreground: Paint()
                                          ..color = Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold)),
                                onPressed: () {
                                  final data = <String, dynamic>{};

                                  if (nickNameController.text.isNotEmpty) {
                                    data['fname'] = nickNameController
                                        .text; //add the key to the data object
                                    context.read<UserProvider>().changeFName(
                                        newFName: nickNameController
                                            .text); //update provider
                                  }
                                  if (emailController.text.isNotEmpty) {
                                    data['email'] = emailController.text;
                                    context.read<UserProvider>().changeEmail(
                                        newEmail: emailController.text);
                                  }
                                  if (incomeController.text.isNotEmpty) {
                                    data['income'] = incomeController.text;
                                    context.read<UserProvider>().changeIncome(
                                        newIncome:
                                            int.parse(incomeController.text));
                                  }
                                  if (savingsController.text.isNotEmpty) {
                                    data['savings_target'] =
                                        savingsController.text;
                                    context
                                        .read<UserProvider>()
                                        .changeSavingsTarget(
                                            newSavingsTarget: int.parse(
                                                savingsController.text));
                                  }
                                  updateUser(data, userID);
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
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(30),
                                child: FilledButton.icon(
                                  label: Text("Back to Profile"),
                                  icon: const Icon(Icons.arrow_back),
                                  iconAlignment: IconAlignment.start,
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
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
