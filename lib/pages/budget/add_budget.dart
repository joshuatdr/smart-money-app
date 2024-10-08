import 'package:flutter/material.dart';
import 'package:smart_money_app/common/sizes.dart';
import 'package:smart_money_app/common/image_strings.dart';
import 'package:smart_money_app/common/styles/spacing_styles.dart';
import 'dart:convert';
import 'package:status_alert/status_alert.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddBudget extends StatefulWidget {
  @override
  State<AddBudget> createState() => _AddBudgetState();
}

class _AddBudgetState extends State<AddBudget> {
  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Success',
      subtitle: 'Expense added!',
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

  void showErrorAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Error',
      subtitle: 'Something went wrong!',
      configuration: IconConfiguration(icon: Icons.error),
    );
  }

  bool isChecked = false;
  bool successMsg = false;
  final _formfield = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final costController = TextEditingController();
  _register(userId) async {
    var data = {
      'name': nameController.text,
      'cost': costController.text,
      'user_id': userId,
    };

    var res = await UserServices().postExpense(data);
    var body = jsonDecode(res.body);

    if (body['expense']['monthly_expense_id'] >= 1) {
      nameController.clear();
      costController.clear();

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
        return 'Please enter a cost';
      } else {
        return null;
      }
    }

    var userId = context.watch<UserProvider>().userID;
    return Scaffold(
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(50.0),
            child: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: true,
              backgroundColor: Colors.lightBlue.shade900,
              title: Text("Add Expense", style: TextStyle(color: Colors.white)),
            )),
        body: SingleChildScrollView(
          child: Padding(
            padding: JSpacingStyle.paddingWithAppBarHeight,
            child: Column(children: [
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
                  // Text("Add expense",
                  //     style: Theme.of(context).textTheme.headlineMedium),
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
                        controller: nameController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.money_off),
                          labelText: "Name",
                        ),
                        validator: validateName,
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      TextFormField(
                        keyboardType: TextInputType.numberWithOptions(),
                        controller: costController,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.money_outlined),
                          labelText: "Cost",
                        ),
                        validator: validateCost,
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      const SizedBox(height: JSizes.spaceBtwItems),
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
                                child: Text("Submit changes"))),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30),
                        child: FilledButton.icon(
                          label: Text("Back"),
                          icon: const Icon(Icons.arrow_back),
                          iconAlignment: IconAlignment.start,
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
          ),
          //
        ));
  }
}
