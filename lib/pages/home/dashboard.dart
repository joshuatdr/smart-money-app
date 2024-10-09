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
          loginFocusGoal: jwtDecodedToken['user']['focus_goal'],
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

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
        title: Text("Home", style: TextStyle(color: Colors.white)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BigCard(
                greeting: context.watch<UserProvider>().newUser
                    ? 'Hello, nice to meet you!'
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
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
              child: Card(
                  child: _SampleCard(
                cardName:
                    'The amount you want to save this month is £${context.watch<UserProvider>().savingsTarget}.\n\nAfter subtracting this from your income of £${context.watch<UserProvider>().income}, you are left with £${context.watch<UserProvider>().income - context.watch<UserProvider>().savingsTarget} to spend on all of your expenses.\n\nAfter subtracting your mandatory expenses of £1000, you have £${context.watch<UserProvider>().income - (context.watch<UserProvider>().savingsTarget + 1000)} left to cover any additional purchases.',
              )),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Card(
                  child: _SampleCard(
                      cardName:
                          'This month you have spent £1550.\n\n${1550 > context.watch<UserProvider>().income - (context.watch<UserProvider>().savingsTarget + 1000) ? 'Although you have gone over your budget this month, try to see this as a learning opportunity. Keeping to a budget is hard and takes practice. Stick with it for the rest of the month and you will be more likely to stay on track next month.' : 'You are currently sticking to your budget! Nice work, you have £${(context.watch<UserProvider>().income - (context.watch<UserProvider>().savingsTarget + 1000)) - 800} left for the rest of the month.'}')),
            )
          ],
        ),
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

class _SampleCard extends StatelessWidget {
  const _SampleCard({required this.cardName});
  final String cardName;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 500,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(child: Text(cardName)),
      ),
    );
  }
}
