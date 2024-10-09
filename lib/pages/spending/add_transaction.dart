import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/common/styles/spacing_styles.dart';
import 'package:smart_money_app/common/sizes.dart';
import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/providers/user_provider.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  // Method to show a success alert
  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Success',
      subtitle: 'Transaction Saved!',
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

  // Method to show an error alert
  void showErrorAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Error',
      subtitle: 'Something went wrong!',
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
      nameController.clear();
      costController.clear();
      imgurlController.clear();
      descController.clear();

      if (!mounted) return;
      showSuccessAlert(context);
    } else {
      if (!mounted) return;
      showErrorAlert(context);
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
    //var userID = context.watch<UserProvider>().userID;

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
      backgroundColor: Colors.grey[300],
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            automaticallyImplyLeading: false,
            centerTitle: true,
            backgroundColor: Colors.lightBlue.shade900,
            title: Text("Add New Transaction",
                style: TextStyle(color: Colors.white)),
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
                            labelText: 'Name',
                          ),
                          validator: validateName),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// Cost
                      TextFormField(
                          controller: costController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.login),
                            labelText: 'Cost',
                          ),
                          validator: validateCost),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// image Url
                      TextFormField(
                        controller: imgurlController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.login),
                          labelText: "Image URL",
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
                                    backgroundColor: Colors.lightBlue.shade900,
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
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: FilledButton.icon(
                            label: Text("Back to Spending"),
                            icon: const Icon(Icons.arrow_back),
                            iconAlignment: IconAlignment.start,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                        ),
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
