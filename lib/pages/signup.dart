import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/login.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import '../common/ttexts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:smart_money_app/services/config.dart';
import 'package:status_alert/status_alert.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  //const LoginScreen({super.key});
  bool isChecked = false;
  final _formfield = GlobalKey<FormState>();
  final passController = TextEditingController();
  final confirmPassController = TextEditingController();
  final emailController = TextEditingController();
  final nickNameController = TextEditingController();
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
                  Text(TTexts.createAccount,
                      style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(
                    height: JSizes.sm,
                  ),
                  Text(TTexts.signUp,
                      style: Theme.of(context).textTheme.bodyMedium),
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
                      /// Email
                      TextFormField(
                          controller: emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: TTexts.email,
                          ),
                          validator: validateEmail),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// Password
                      TextFormField(
                          controller: passController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: TTexts.password,
                          ),
                          validator: validatePass),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// confirm Password
                      TextFormField(
                          controller: confirmPassController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: "confirm password",
                          ),
                          validator: validatePass),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// nick name
                      TextFormField(
                        controller: nickNameController,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          labelText: TTexts.friendlyName,
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter a nick name";
                          }
                          return null;
                        },
                      ),
                      FormField(
                          autovalidateMode: AutovalidateMode.always,
                          initialValue: false,
                          validator: (value) {
                            if (value != true) {
                              return "You need to accept terms!";
                            }
                            return null;
                          },
                          builder: (FormFieldState<bool> state) {
                            return SizedBox(
                              width: 300,
                              child: CheckboxListTile(
                                  title: const Text("Agree Terms of Service"),
                                  subtitle: state.hasError
                                      ? Text(
                                          state.errorText!,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        )
                                      : null,
                                  value: state.value,
                                  onChanged: (val) {
                                    if (val == true) {
                                      isChecked = true;
                                    } else {
                                      isChecked = false;
                                    }
                                    state.didChange(val);
                                  }),
                            );
                          }),
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
                                    passController.clear();
                                    emailController.clear();
                                    nickNameController.clear();
                                    confirmPassController.clear();
                                  }
                                  isChecked == false
                                      ? print("please accept")
                                      : isChecked == false;
                                },
                                child: Text(TTexts.signUp))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                              '\u2022 A password must be at least 8 characters long.'),
                          Text(
                              '\u2022 A password must contain at least a number.'),
                          Text(
                              '\u2022 A password must contain an uppercase letter'),
                          Text(
                              '\u2022 A password must contain a lowercase letter'),
                          Text(
                              '\u2022 A password must contain a special character.'),
                          Padding(
                            padding: const EdgeInsets.all(60),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => LoginScreen()));
                                },
                                child: const Text("Already have an account?")),
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
