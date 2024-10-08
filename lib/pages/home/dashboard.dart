import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:smart_money_app/navigation/budget_nav.dart';
import 'package:smart_money_app/navigation/goals_nav.dart';
import 'package:smart_money_app/navigation/profile_nav.dart';
import 'dart:math';
import 'package:smart_money_app/pages/auth/login.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:smart_money_app/navigation/spending_nav.dart';

class Dashboard extends StatefulWidget {
  final String token;
  final bool firstLogin;
  const Dashboard({required this.token, required this.firstLogin, super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late int userID;
  @override
  void initState() {
    super.initState();
    parseToken();
  }

  void parseToken() async {
    Map<String, dynamic> jwtDecodedToken =
        await JwtDecoder.decode(widget.token);
    if (!mounted) return;
    context.read<UserProvider>().loginUser(
          loginUserID: jwtDecodedToken['user']['user_id'],
          loginEmail: jwtDecodedToken['user']['email'],
          loginAvatarURL: jwtDecodedToken['user']['avatar_url'],
          loginFName: jwtDecodedToken['user']['fname'],
          loginIncome: jwtDecodedToken['user']['income'],
          loginSavingsTarget: jwtDecodedToken['user']['savings_target'],
          loginCreatedAt: jwtDecodedToken['user']['created_at'],
          firstLogin: widget.firstLogin,
        );
  }

  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;

    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: IndexedStack(
          index: selectedIndex,
          children: [
            HomePage(),
            GoalsNav(),
            BudgetNav(),
            SpendingNav(),
            ProfileNav(),
          ],
        ),
      ),
    );

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 510) {
            return Column(
              children: [
                Expanded(child: mainArea),
                SafeArea(
                  child: BottomNavigationBar(
                    type: BottomNavigationBarType.fixed,
                    items: [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.savings),
                        label: 'Goals',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.pie_chart),
                        label: 'Budget',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.payments),
                        label: 'Spending',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.account_circle),
                        label: 'Profile',
                      ),
                    ],
                    currentIndex: selectedIndex,
                    onTap: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
              ],
            );
          } else {
            return Row(
              children: [
                SafeArea(
                  child: NavigationRail(
                    extended: constraints.maxWidth >= 600,
                    destinations: [
                      NavigationRailDestination(
                        icon: Icon(Icons.home),
                        label: Text('Home'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.savings),
                        label: Text('Goals'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.pie_chart),
                        label: Text('Budget'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.payments),
                        label: Text('Spending'),
                      ),
                      NavigationRailDestination(
                        icon: Icon(Icons.account_circle),
                        label: Text('Profile'),
                      ),
                    ],
                    selectedIndex: selectedIndex,
                    onDestinationSelected: (value) {
                      setState(() {
                        selectedIndex = value;
                      });
                    },
                  ),
                ),
                Expanded(child: mainArea),
              ],
            );
          }
        },
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    List greetings = [
      "Welcome back!\n Ready to grow your savings today?",
      "Good to see you again!\n Let's make your savings work harder.",
      "You're back!\n Let’s check in on your savings progress.",
      "Welcome back!\n Every step counts—how can we help you save more today?",
      "Hey there, great to have you back!\n Let’s boost those savings.",
      "Nice to see you again!\n Your savings journey continues here.",
      "Welcome back!\n Let’s keep building towards your financial goals.",
      "You're back!\n Ready to watch your savings grow?",
      "Hello again!\n Let’s take another step toward your savings target.",
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(
              greeting: context.watch<UserProvider>().newUser
                  ? 'Welcome'
                  : greetings[Random().nextInt(greetings.length)]),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (ctx) => LoginScreen()),
                  (route) => false);
              context.read<UserProvider>().logoutUser();
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    required this.greeting,
    Key? key,
  }) : super(key: key);

  final String greeting;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var style = theme.textTheme.displayMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    return Card(
      color: Colors.lightBlue.shade900,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              context.watch<UserProvider>().fName,
              style: style.copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              greeting,
              textAlign: TextAlign.center,
              style: style.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
