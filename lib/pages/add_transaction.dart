import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_money_app/services/api.dart';
import '../common/styles/spacing_styles.dart';
import '../common/sizes.dart';
import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';


class AddTransactionScreen extends StatefulWidget {
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // Method to show a success alert
  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 4),
      title: 'Success',
      subtitle: 'Transaction Saved!',
      configuration: IconConfiguration(icon: Icons.check),
      backgroundColor: const Color.fromARGB(255, 255, 199, 116),
    );
  }

  // Method to show an error alert
  void showErrorAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Error',
      subtitle: 'Something went wrong!',
      configuration: IconConfiguration(icon: Icons.error),
    );
  }

  //const LoginScreen({super.key});
  bool isChecked = false;
  bool successMsg = false;
  final _formfield = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final costController = TextEditingController();
  final imgurlController = TextEditingController();
  final descController = TextEditingController();


  _register(userId) async {
    var data = {
      'name': nameController.text,
      'cost': costController.text,
      'img_url': imgurlController.text,
      'description': descController.text,
      'user_id': userId,
    };

    var res = await UserServices().postUserTransaction(data, 'transactions');
    var body = jsonDecode(res.body);

    if (body['transaction']['transaction_id'] >= 1) {
      // successMsg = true;
      print('success');
      nameController.clear();
      costController.clear();
      imgurlController.clear();
      descController.clear();
      return successMsg = true;
    } else {
      successMsg = false;
      print('it failed');
      return;
    }
  }

  var dark = false;
  // List<String> str = ['A password must be at least 8 characters long.',
  //       'Must contain an uppercase',
  //       'lowercase letter',
  //       'A number',
  //       'A special character'];
  @override
  Widget build(BuildContext context) {

    var userID = context.watch<UserProvider>().userID;

//print(userID);
    
    // String? validatePass(String? value) {
    //   const patternPass = r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$";
    //   final regex = RegExp(patternPass);

    //   if (value!.isEmpty) {
    //     return 'A password must be at least 8 characters long.'
    //     ' must contain an uppercase'
    //     'lowercase letter'
    //     'A number'
    //     'A special character';
    //   } else {
    //     return value.isNotEmpty && !regex.hasMatch(value)
    //         ? 'A password must be at least 8 characters long, must contain an uppercase, lowercase letter, a number and a special character'
    //         : null;
    //   }
    // }

    String? validateName(value) {
      if (value!.isEmpty) {
        return 'Enter a valid name';
      } else {
        return null;
      }
    }

    String? validateCost(value) {
      if (value!.isEmpty) {
        return 'Please enter a purchase cost';
      } else {
        return null;
      }
    }

    var userId = context.watch<UserProvider>().userID;
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Colors.orange,
            title: Center(
                child: Text("Add Transaction",
                    style: TextStyle(color: Colors.white))),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: JSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              // /// Logo, Title & Sub Title
              // Column(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Padding(
              //       padding: const EdgeInsets.only(
              //           left: 50, right: 50, top: 10, bottom: 50),
              //       child: Image(
              //         image: AssetImage(dark ? JImages.flag : JImages.flag),
              //       ),
              //     ),
              //     Text(TTexts.createAccount,
              //         style: Theme.of(context).textTheme.headlineMedium),
              //     const SizedBox(
              //       height: JSizes.sm,
              //     ),
              //     Text(TTexts.signUp,
              //         style: Theme.of(context).textTheme.bodyMedium),
              //   ],
              // ),

              /// Form
              Form(
                key: _formfield,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: JSizes.spaceBtwItems),
                  child: Column(
                    children: [
                      /// Name
                      TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText: 'name',
                          ),
                          validator: validateName),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// Cost
                      TextFormField(
                          controller: costController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: 'cost',
                          ),
                          validator: validateCost),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// image Url
                      TextFormField(
                        controller: imgurlController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.login),
                          labelText: "Image Url",
                        ),
                        // validator: validateImg
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// description
                      TextFormField(
                        maxLines: 3,
                        controller: descController,
                        obscureText: false,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.alternate_email),
                          labelText: 'Description',
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return "please enter a nick name";
                        //   }
                        //   return null;
                        // },
                      ),
                      // FormField(
                      //   autovalidateMode: AutovalidateMode.always,
                      //   initialValue: false,
                      //   validator: (value) {
                      //     if (value != true) {
                      //       return "You need to accept terms!";
                      //     }
                      //     return null;
                      //   },
                      //   builder: (FormFieldState<bool> state) {
                      //     return SizedBox(
                      //       width: 300,
                      //       child: CheckboxListTile(
                      //           title: const Text("Agree Terms of Service"),
                      //           subtitle: state.hasError
                      //               ? Text(
                      //                   state.errorText!,
                      //                   style: const TextStyle(color: Colors.red),
                      //                 )
                      //               : null,
                      //           value: state.value,
                      //           onChanged: (val) {
                      //             if (val == true) {
                      //               isChecked = true;
                      //             } else {
                      //               isChecked = false;
                      //             }
                      //             state.didChange(val);
                      //           }),
                      //     );
                      //   }
                      // ),
                      // const SizedBox(height: JSizes.spaceBtwItems),

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
                                  if (_formfield.currentState!.validate()) {
                                    // print("success");

                                    _register(userId);

                                    print(successMsg);

                                    if (successMsg) {
                                      showSuccessAlert(context);
                                    } else {
                                      showErrorAlert(context);
                                      successMsg = false;
                                    }

                                    /*     passController.clear();
                                    emailController.clear();
                                    nickNameController.clear();
                                    confirmPassController.clear();*/
                                  }
                                  /* isChecked == false
                                      ? print("please accept")
                                      : isChecked == false;*/
                                },
                                child: Text('Add Transaction'))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /*   Text('\u2022 A password must be at least 8 characters long.'),
                          Text('\u2022 A password must contain at least a number.'),
                          Text('\u2022 A password must contain an uppercase letter'),
                          Text('\u2022 A password must contain a lowercase letter'),
                          Text('\u2022 A password must contain a special character.'),*/
                          // Padding(
                          //   padding: const EdgeInsets.all(60),
                          //   child:
                          //   TextButton(
                          //       onPressed: () {
                          //         Navigator.pop(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) => LoginScreen()),
                          //         );
                          //       },
                          //       child: const Text("Already have an account?")),
                          // ),
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
