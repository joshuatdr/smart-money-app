import 'package:flutter/material.dart';
import 'package:smart_money_app/main.dart';
import 'package:smart_money_app/pages/signup.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import '../common/ttexts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './config.dart';
import 'package:status_alert/status_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_money_app/globals.dart' as globals;
import './dashboard.dart';

var fname = globals.fname;

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //const LoginScreen({super.key});
  bool isChecked = false;
  final _formfield = GlobalKey<FormState>();
  final passController = TextEditingController();
  final emailController = TextEditingController();
  var dark = false;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async {
    var reqBody = {
      "email": emailController.text,
      "password": passController.text,
    };

    var response = await http.post(Uri.parse(login),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(reqBody));

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);
      // globals.userId = userID;
      // AlertDialog(
      //     title: Text("logged in"),
      //     content: Text('$fname logged in successfully.'),
      //     actions: [
      //       MaterialButton(
      //           child: Text("OK"),
      //           onPressed: () {
      //             Navigator.of(context).pop();
      //           })
      //     ]);
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => Dashboard(token: myToken)));
    } else {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: 'Error',
        subtitle: 'Incorrect login',
        configuration: IconConfiguration(icon: Icons.error),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    String? validatePass(String? value) {
      if (value!.isEmpty) {
        return 'Please enter a password.';
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
                  Text(TTexts.loginTitle,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(
                    height: JSizes.sm,
                  ),
                  Text(TTexts.loginSubTitle,
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),

              /// Form
              Form(
                autovalidateMode: AutovalidateMode.always,
                key: _formfield,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: JSizes.spaceBtwItems),
                  child: Column(
                    children: [
                      /// Email
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.email),
                          labelText: TTexts.email,
                        ),
                        validator: validateEmail,
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// Password
                      TextFormField(
                        obscureText: true,
                        controller: passController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.login),
                          labelText: TTexts.password,
                        ),
                        validator: validatePass,
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// remember me and forget password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Remember Me
                          Row(
                            children: [
                              Checkbox(
                                  value: isChecked,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  }),
                              const Text(TTexts.rememberMe),
                            ],
                          ),

                          // Forgot Password
                          TextButton(
                              onPressed: () {},
                              child: const Text(TTexts.forgotPassword)),
                        ],
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
                                  _formfield.currentState!.validate();
                                  loginUser();
                                },
                                child: Text(TTexts.signIn))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: SizedBox(
                            width: double.infinity,
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
                                        builder: (context) => SignupScreen()),
                                  );
                                },
                                child: Text(TTexts.createAccount))),
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
