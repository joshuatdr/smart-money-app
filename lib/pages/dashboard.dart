import 'package:flutter/material.dart';
import 'package:smart_money_app/main.dart';
import 'package:smart_money_app/pages/Spending.dart';
import 'package:smart_money_app/pages/history.dart';
import 'package:smart_money_app/pages/Budget.dart';
import 'package:smart_money_app/pages/goals.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'profile.dart';

class Dashboard extends StatefulWidget {
  final token;
  const Dashboard({@required this.token, super.key});

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
    context
        .read<UserProvider>()
        .changeUserID(newUserID: jwtDecodedToken['user']['user_id']);
    context
        .read<UserProvider>()
        .changeEmail(newEmail: jwtDecodedToken['user']['email']);
    context
        .read<UserProvider>()
        .changeAvatarURL(newAvatarURL: jwtDecodedToken['user']['avatar_url']);
    context
        .read<UserProvider>()
        .changeFName(newFName: jwtDecodedToken['user']['fname']);
    context
        .read<UserProvider>()
        .changeIncome(newIncome: jwtDecodedToken['user']['income']);
    context.read<UserProvider>().changeSavingsTarget(
        newSavingsTarget: jwtDecodedToken['user']['savings_target']);
    context
        .read<UserProvider>()
        .changeCreatedAt(newCreatedAt: jwtDecodedToken['user']['created_at']);
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
          BigCard(greeting: 'Welcome back'),
          ElevatedButton(
            onPressed: () {},
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
