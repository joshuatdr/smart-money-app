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

class ChangeAccessibility extends StatefulWidget {
  @override
  _ChangeAccessibility createState() => _ChangeAccessibility();
}

class _ChangeAccessibility extends State<ChangeAccessibility> {
  bool isAccessibilityEnabled = false;

  @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: Transform.scale(scale isAccessibilityEnabled ? 1.25 : 1.0, 
        child: Center(child: Column(mainAxisAlignment: MainAxisAlignment.center,),))
      SizedBox(height: 20),
      ElevatedButton(onPressed: () {
        setState(() {
          isAccessibilityEnabled = !isAccessibilityEnabled
        })
      },))
    }
  }