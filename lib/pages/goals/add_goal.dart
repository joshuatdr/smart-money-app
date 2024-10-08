import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/goals/goals.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:status_alert/status_alert.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:smart_money_app/common/sizes.dart';
import 'package:smart_money_app/common/styles/spacing_styles.dart';

class AddGoalPage extends GoalsPage {
  @override
  State<AddGoalPage> createState() => _AddGoalPageState();
}

class _AddGoalPageState extends State<AddGoalPage> {
  // Method to show a success alert
  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Success',
      subtitle: 'Goal added!',
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

    var res = await UserServices().postUserGoal(data);
    var body = jsonDecode(res.body);

    if (body['goal']['goal_id'] >= 1) {
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

  @override
  Widget build(BuildContext context) {
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
            title: Text("Add New Goal", style: TextStyle(color: Colors.white)),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: JSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
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
                            filled: true,
                            fillColor: Colors.white,
                            // prefixIcon: Icon(Icons.abc_rounded),
                            labelText: 'Name',
                          ),
                          validator: validateName),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// Cost
                      TextFormField(
                          controller: costController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            // prefixIcon: Icon(Icons.login),
                            labelText: 'Cost',
                          ),
                          validator: validateCost),
                      const SizedBox(height: JSizes.spaceBtwItems),

                      /// image Url
                      TextFormField(
                        controller: imgurlController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          // prefixIcon: Icon(Icons.login),
                          labelText: "Image URL (optional)",
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
                          filled: true,
                          fillColor: Colors.white,
                          // prefixIcon: Icon(Icons.alternate_email),
                          labelText: 'Description (optional)',
                        ),
                      ),

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
                                  }
                                },
                                child: Text('Done'))),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(30),
                          child: FilledButton.icon(
                            label: Text("Back to Goals"),
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
