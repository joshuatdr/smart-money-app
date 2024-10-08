import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/profile/profile.dart';
import 'package:smart_money_app/common/styles/spacing_styles.dart';
import 'package:smart_money_app/common/image_strings.dart';
import 'package:smart_money_app/common/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_money_app/providers/user_provider.dart';

class ChangePass extends StatefulWidget {
  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  late SharedPreferences prefs;
  bool passwordVisible = false;
  bool passwordVisibleCurrent = false;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    passwordVisibleCurrent = true;
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

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

  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Success',
      subtitle: 'Password Changed',
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

  void showErrorAlert(BuildContext context, message) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Error',
      subtitle: message,
      configuration: IconConfiguration(
        icon: Icons.error,
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
  }

  Future<void> passwordChangeRequest(newPass, currPassCheck, userID) async {
    var response = await http.post(
        Uri.parse("https://smart-money-backend.onrender.com/api/login"),
        headers: {"Content-Type": "application/json"},
        body: currPassCheck);

    if (response.statusCode == 200) {
      var jsonResponse = jsonDecode(response.body);
      var myToken = jsonResponse['token'];
      prefs.setString('token', myToken);

      var patchBody = {"password": newPass};

      final passChangeResponse = await http.patch(
        Uri.parse("https://smart-money-backend.onrender.com/api/user/$userID"),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode(patchBody),
      );
      if (passChangeResponse.statusCode == 201) {
        if (!mounted) return;
        showSuccessAlert(context);
      } else {
        if (!mounted) return;
        showErrorAlert(context, 'Something went wrong');
        // If the server did not return a 201 OK response,
        // then throw an exception.
      }
    } else {
      if (!mounted) return;
      showErrorAlert(context, 'Incorrect Password');
    }
  }

  final _formfield = GlobalKey<FormState>();
  final passController = TextEditingController();
  final newPassController = TextEditingController();
  final confirmPassController = TextEditingController();
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
    var email = context.watch<UserProvider>().email;

    String? validatePass(String? value) {
      const patternPass =
          r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
      final regex = RegExp(patternPass);

      if (value!.isNotEmpty && !regex.hasMatch(value)) {
        return 'A password must be at least 8 characters long, must contain an uppercase, lowercase letter, a number and a special character';
      } else if (value.isEmpty) {
        return 'Please enter a password';
      }
      return null;
    }

    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Padding(
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
                Text("Change Password",
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
                padding:
                    const EdgeInsets.symmetric(vertical: JSizes.spaceBtwItems),
                child: Column(
                  children: [
                    TextFormField(
                      controller: passController,
                      obscureText: passwordVisibleCurrent,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        errorMaxLines: 3,
                        prefixIcon: Icon(Icons.password),
                        labelText: "Current Password",
                        suffixIcon: IconButton(
                          icon: Icon(passwordVisibleCurrent
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(
                              () {
                                passwordVisibleCurrent =
                                    !passwordVisibleCurrent;
                              },
                            );
                          },
                        ),
                        alignLabelWithHint: false,
                      ),
                      validator: validatePass,
                    ),

                    const SizedBox(height: JSizes.spaceBtwItems),

                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: newPassController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          errorMaxLines: 3,
                          prefixIcon: Icon(Icons.edit),
                          labelText: "New Password",
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                          alignLabelWithHint: false,
                        ),
                        validator: validatePass),

                    const SizedBox(height: JSizes.spaceBtwItems),

                    TextFormField(
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        controller: confirmPassController,
                        obscureText: passwordVisible,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          errorMaxLines: 3,
                          prefixIcon: Icon(Icons.loop),
                          labelText: "Confirm New Password",
                          suffixIcon: IconButton(
                            icon: Icon(passwordVisible
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(
                                () {
                                  passwordVisible = !passwordVisible;
                                },
                              );
                            },
                          ),
                          alignLabelWithHint: false,
                        ),
                        validator: validatePass),

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
                                      foreground: Paint()..color = Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              onPressed: () {
                                if (_formfield.currentState!.validate()) {
                                  if (newPassController.text ==
                                      confirmPassController.text) {
                                    final data = <String, dynamic>{};
                                    data['password'] = passController.text;
                                    data['email'] = email;
                                    passwordChangeRequest(
                                      newPassController.text,
                                      jsonEncode(data),
                                      userID,
                                    );
                                  } else {
                                    StatusAlert.show(
                                      context,
                                      duration: Duration(seconds: 2),
                                      title: 'Error',
                                      subtitle: "Passwords Don't Match",
                                      configuration: IconConfiguration(
                                        icon: Icons.error,
                                        color: Colors.white,
                                      ),
                                      backgroundColor: Colors.lightBlue.shade900
                                          .withOpacity(.9),
                                      subtitleOptions:
                                          StatusAlertTextConfiguration(
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      ),
                                      titleOptions:
                                          StatusAlertTextConfiguration(
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 24),
                                      ),
                                    );
                                  }
                                }
                              },
                              child: Text("Submit"))),
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
    );
  }
}
