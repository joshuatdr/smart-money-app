import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/goals/add_goal.dart';
import 'package:smart_money_app/pages/goals/goals.dart';

class GoalsNav extends StatefulWidget {
  const GoalsNav({super.key});

  @override
  State<GoalsNav> createState() => _GoalsNavState();
}

class _GoalsNavState extends State<GoalsNav> {
  GlobalKey<NavigatorState> goalsNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: goalsNavigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                if (settings.name == '/addgoal') {
                  return AddGoalPage();
                }
                return GoalsPage();
              });
        });
  }
}
