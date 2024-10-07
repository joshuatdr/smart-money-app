import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/budget/budget.dart';
import 'package:smart_money_app/pages/budget/edit_budget.dart';

class BudgetNav extends StatefulWidget {
  const BudgetNav({super.key});

  @override
  State<BudgetNav> createState() => _BudgetNavState();
}

class _BudgetNavState extends State<BudgetNav> {
  GlobalKey<NavigatorState> budgetNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: budgetNavigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                if (settings.name == '/editbudget') {
                  return EditBudgetPage();
                }
                return BudgetPage();
              });
        });
  }
}
