import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/profile.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import '../providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePass extends StatefulWidget {
  @override
  State<ChangePass> createState() => _ChangePassState();
}

class _ChangePassState extends State<ChangePass> {
  late SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async {
    prefs = await SharedPreferences.getInstance();
  }

  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Success',
      subtitle: 'Password Changed',
      configuration: IconConfiguration(icon: Icons.check),
      backgroundColor: Colors.lightBlue.shade600,
    );
    Navigator.pop(context);
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
        showSuccessAlert(context);
      } else {
        print('FAIL');
        // If the server did not return a 201 OK response,
        // then throw an exception.
      }
    } else {
      StatusAlert.show(
        context,
        duration: Duration(seconds: 2),
        title: 'Error',
        subtitle: 'Incorrect Password',
        configuration: IconConfiguration(icon: Icons.error),
      );
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
    }

    return Scaffold(
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
                      obscureText: true,
                      decoration: InputDecoration(
                        errorMaxLines: 3,
                        prefixIcon: Icon(Icons.password),
                        labelText: "Current Password",
                      ),
                      validator: validatePass,
                    ),

                    const SizedBox(height: JSizes.spaceBtwItems),

                    TextFormField(
                        controller: newPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          prefixIcon: Icon(Icons.edit),
                          labelText: "New Password",
                        ),
                        validator: validatePass),

                    const SizedBox(height: JSizes.spaceBtwItems),

                    TextFormField(
                        controller: confirmPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          errorMaxLines: 3,
                          prefixIcon: Icon(Icons.loop),
                          labelText: "Confirm New Password",
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
                                  if (newPassController.text == confirmPassController.text) {             
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
                                      configuration:
                                          IconConfiguration(icon: Icons.error),
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
    );
  }
}
