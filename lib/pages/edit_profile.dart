import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/login.dart';
import 'package:smart_money_app/pages/testapi.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import '../common/ttexts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './config.dart';
import 'package:status_alert/status_alert.dart';

class EditProfile extends StatefulWidget {
  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
   Future<void> updateUser(String body) async {
  final response = await http.put(
    Uri.parse("https://smart-money-backend.onrender.com/api/user/1/"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'Email': "JimTest@gmail.com",
    }),
  );

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to update album.');
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

  void registerUser() async {
    var reqBody = {
      "email": emailController.text,
      "password": passController.text,
      "fname": nickNameController.text,
    };
    var response = await http.post(
      Uri.parse(postUser),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(reqBody),
    );
    var jsonResponse = jsonDecode(response.body);
    if (response.statusCode == 201) {
      // print("got status 201");
      // print(jsonResponse);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginScreen()));
    } else {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: 'Error',
        subtitle: 'A user already exists with that email.',
        configuration: IconConfiguration(icon: Icons.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          validator: validateEmail),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: "Email",
                          ),
                          validator: validatePass),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: "Password",
                          ),
                          validator: validatePass),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      TextFormField(
                        controller: incomeController,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          labelText: "Income",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter a nick name";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      TextFormField(
                        controller: savingsController,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          labelText: "Savings target",
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter a nick name";
                          }
                          return null;
                        },
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
                                onPressed: () {
                                  if (_formfield.currentState!.validate() &&
                                      isChecked) {
                                    registerUser();
                                    print("success");
                                  }
                                  isChecked == false
                                      ? print("please accept")
                                      : isChecked == false;
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
