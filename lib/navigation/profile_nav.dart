import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/profile/change_password.dart';
import 'package:smart_money_app/pages/profile/edit_profile.dart';
import 'package:smart_money_app/pages/profile/profile.dart';

class ProfileNav extends StatefulWidget {
  const ProfileNav({super.key});

  @override
  State<ProfileNav> createState() => _ProfileNavState();
}

class _ProfileNavState extends State<ProfileNav> {
  GlobalKey<NavigatorState> profileNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: profileNavigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                if (settings.name == '/changepass') {
                  return ChangePass();
                } else if (settings.name == '/editprofile') {
                  return EditProfile();
                }
                return UserScreen();
              });
        });
  }
}
