import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/login.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import '../common/ttexts.dart';

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

  @override
  Widget build(BuildContext context) {
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
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "please enter password";
                          } else if (value != confirmPassController.text) {
                            return "passwords don't match";
                          } else {
                            return null;
                          }
                        },
                      ),

                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// confirm Password
                      TextFormField(
                        controller: confirmPassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.login),
                          labelText: "confirm password",
                        ),
                        validator: (value) {
                          if (value != passController.text) {
                            return "passwords don't match";
                          } else {
                            return null;
                          }
                        },
                      ),

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

                      /// checkbox
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
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
                            ],
                          ),

                          // Terms and conditions
                          TextButton(
                              onPressed: () {},
                              child: const Text(TTexts.terms)),
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
                                  if (_formfield.currentState!.validate() &&
                                      isChecked) {
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
                      Padding(
                        padding: const EdgeInsets.all(60),
                        child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()),
                              );
                            },
                            child: const Text("Already have an account?")),
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
