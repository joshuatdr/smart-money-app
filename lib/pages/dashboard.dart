import 'package:flutter/material.dart';
import 'package:smart_money_app/main.dart';
import 'package:smart_money_app/pages/Spending.dart';
import 'package:smart_money_app/pages/history.dart';
import 'package:smart_money_app/pages/Budget.dart';
import 'package:smart_money_app/pages/goals.dart';
import 'package:provider/provider.dart';
import 'package:smart_money_app/pages/login.dart';
import '../providers/user_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'profile.dart';

class Dashboard extends StatefulWidget {
  final token;
  final bool firstLogin;
  const Dashboard({@required this.token, required this.firstLogin, super.key});

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

    Widget page = Placeholder();
    switch (selectedIndex) {
      case 0:
        page = HomePage();
      case 1:
        page = GoalsPage();
      case 2:
        page = BudgetPage();
      case 3:
        page = SpendingPage();
      case 4:
        page = HistoryScreen();
      case 5:
        page = UserScreen();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    var mainArea = ColoredBox(
      color: colorScheme.surfaceContainerHighest,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 200),
        child: page,
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
                        icon: Icon(Icons.insights),
                        label: 'History',
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
                )
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
                        icon: Icon(Icons.insights),
                        label: Text('History'),
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
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(
              greeting: context.watch<UserProvider>().newUser
                  ? 'Welcome'
                  : 'Welcome back'),
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
      color: theme.colorScheme.primary,
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
              style: style.copyWith(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
