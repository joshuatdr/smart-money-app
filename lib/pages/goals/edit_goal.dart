import 'package:flutter/material.dart';
import 'package:smart_money_app/services/api.dart';
import 'package:smart_money_app/pages/spending/history.dart';
import 'package:smart_money_app/common/styles/spacing_styles.dart';
import 'package:smart_money_app/common/sizes.dart';
import 'package:provider/provider.dart';
import 'package:status_alert/status_alert.dart';
import 'package:smart_money_app/providers/user_provider.dart';

class EditGoal extends StatefulWidget {
  const EditGoal(
      {Key? key,
      this.name,
      this.cost,
      this.imgUrl,
      this.desc,
      this.createdAt,
      this.goalId})
      : super(key: key);

  final int? goalId;
  final String? name;
  final num? cost;
  final String? imgUrl;
  final String? createdAt;
  final String? desc;

  @override
  State<EditGoal> createState() => _EditGoalState();
}

class _EditGoalState extends State<EditGoal> {
  void showSuccessAlert(BuildContext context) {
    StatusAlert.show(
      context,
      duration: Duration(seconds: 2),
      title: 'Success',
      subtitle: 'Goal Updated',
      configuration: IconConfiguration(icon: Icons.check),
      backgroundColor: Colors.lightBlue.shade600,
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
      configuration: IconConfiguration(icon: Icons.error),
    );
  }

  final _formfield = GlobalKey<FormState>();
  late final nameController = TextEditingController(text: widget.name);
  late final costController =
      TextEditingController(text: widget.cost.toString());
  late final imgUrlController = TextEditingController(text: widget.imgUrl);
  late final descController = TextEditingController(text: widget.desc);

  _edit(data, userId) async {
    // print(data);
    // print(userId);

    var res = await UserServices()
        .patchUserTransaction(data, '$userId/goals/${widget.goalId}');

    // print(res.statusCode);

    if (res.statusCode == 200) {
      if (!mounted) return;
      showSuccessAlert(context);
    } else {
      // print('FAIL');
      if (!mounted) return;
      showErrorAlert(context);
    }
  }

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

    //AsyncSnapshot.waiting();
    final userID = context.watch<UserProvider>().userID;

    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: AppBar(
            centerTitle: true,
            backgroundColor: Colors.lightBlue.shade900,
            title: Text("Edit Goal", style: TextStyle(color: Colors.white)),
          )),
      body: SingleChildScrollView(
        child: Padding(
          padding: JSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name.toString(),
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
                        controller: nameController,
                        decoration: InputDecoration(
                          //   prefixIcon: Icon(Icons.email),
                          labelText: "Name",
                        ),
                        validator: validateName,
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      TextFormField(
                        controller: costController,
                        obscureText: false,
                        decoration: InputDecoration(
                          // prefixIcon: Icon(Icons.alternate_email),
                          labelText: "Cost",
                        ),
                        validator: validateCost,
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      if (imgUrlController.text.isNotEmpty)
                        SizedBox(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              imgUrlController.text,
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      TextFormField(
                        controller: imgUrlController,
                        obscureText: false,
                        decoration: InputDecoration(
                          //  prefixIcon: Icon(Icons.alternate_email),
                          labelText: "Image Url",
                        ),
                      ),
                      const SizedBox(height: JSizes.spaceBtwItems),
                      TextFormField(
                        maxLines: 2,
                        controller: descController,
                        obscureText: false,
                        decoration: InputDecoration(
                          //    prefixIcon: Icon(Icons.alternate_email),
                          labelText: 'Description',
                        ),
                      ),
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
                                    final data = <String, dynamic>{};

                                    if (nameController.text.isNotEmpty) {
                                      data['name'] = nameController.text;
                                    }
                                    if (costController.text.isNotEmpty) {
                                      data['cost'] = costController.text;
                                    }
                                    if (imgUrlController.text.isNotEmpty) {
                                      data['img_url'] = imgUrlController.text;
                                    }
                                    if (descController.text.isNotEmpty) {
                                      data['description'] = descController.text;
                                    }
                                    print(data);
                                    _edit(data, userID);
                                  }
                                },
                                child: Text("Submit changes"))),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
