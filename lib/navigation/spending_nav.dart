import 'package:flutter/material.dart';
import 'package:smart_money_app/pages/spending/add_transaction.dart';
import 'package:smart_money_app/pages/spending/history.dart';
import 'package:smart_money_app/pages/spending/graph.dart';

class SpendingNav extends StatefulWidget {
  const SpendingNav({super.key});

  @override
  State<SpendingNav> createState() => _SpendingNavState();
}

class _SpendingNavState extends State<SpendingNav> {
  GlobalKey<NavigatorState> spendingNavigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
        key: spendingNavigatorKey,
        onGenerateRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              settings: settings,
              builder: (BuildContext context) {
                if (settings.name == '/spending') {
                  return SpendingPage();
                } else if (settings.name == '/addtransaction') {
                  return AddTransactionScreen();
                }
                return HistoryScreen();
              });
        });
  }
}
