import 'package:flutter/material.dart';
import 'package:smart_money_app/main.dart';
import 'package:smart_money_app/spending_page.dart';
import 'package:smart_money_app/pages/history.dart';
import 'package:smart_money_app/pages/budget.dart';
import 'package:smart_money_app/pages/goals.dart';
import 'package:smart_money_app/pages/add_transaction.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:english_words/english_words.dart';
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

//       context
//           .read<UserProvider>()
//           .changeUserID(newUserID: jwtDecodedToken['user']['user_id']);
//       context
//           .read<UserProvider>()
//           .changeEmail(newEmail: jwtDecodedToken['user']['email']);
//       context
//           .read<UserProvider>()
//           .changeAvatarURL(newAvatarURL: jwtDecodedToken['user']['avatar_url']);
//       context
//           .read<UserProvider>()
//           .changeFName(newFName: jwtDecodedToken['user']['fname']);
//       context
//           .read<UserProvider>()
//           .changeIncome(newIncome: jwtDecodedToken['user']['income']);
//       context
//           .read<UserProvider>()
//           .changeSavingsTarget(newSavingsTarget: jwtDecodedToken['user']['savings_target']);
//       context
//           .read<UserProvider>()
//           .changeCreatedAt(newCreatedAt: jwtDecodedToken['user']['created_at']);

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
      case 6:
        page = AddTransactionScreen();

      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }

    // The container for the current page, with its background color
    // and subtle switching animation.
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
            // Use a more mobile-friendly layout with BottomNavigationBar
            // on narrow screens.
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
                      BottomNavigationBarItem(
                        icon: Icon(Icons.add),
                        label: 'Add Trans',
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
                      NavigationRailDestination(
                        icon: Icon(Icons.add),
                        label: Text('Add Transaction'),
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
          Expanded(
            flex: 3,
            child: HistoryListView(),
          ),
          SizedBox(height: 10),
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('UserID: ${context.watch<UserProvider>().userID}'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
          Spacer(flex: 2),
        ],
      ),
    );
  }
}

class BigCard extends StatelessWidget {
  const BigCard({
    Key? key,
    required this.pair,
  }) : super(key: key);

  final WordPair pair;

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
        child: AnimatedSize(
          duration: Duration(milliseconds: 200),
          // Make sure that the compound word wraps correctly when the window
          // is too narrow.
          child: MergeSemantics(
            child: Wrap(
              children: [
                Text(
                  pair.first,
                  style: style.copyWith(fontWeight: FontWeight.w200),
                ),
                Text(
                  pair.second,
                  style: style.copyWith(fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class HistoryListView extends StatefulWidget {
  const HistoryListView({Key? key}) : super(key: key);

  @override
  State<HistoryListView> createState() => _HistoryListViewState();
}

class _HistoryListViewState extends State<HistoryListView> {
  /// Needed so that [MyAppState] can tell [AnimatedList] below to animate
  /// new items.
  final _key = GlobalKey();

  /// Used to "fade out" the history items at the top, to suggest continuation.
  static const Gradient _maskingGradient = LinearGradient(
    // This gradient goes from fully transparent to fully opaque black...
    colors: [Colors.transparent, Colors.black],
    // ... from the top (transparent) to half (0.5) of the way to the bottom.
    stops: [0.0, 0.5],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<MyAppState>();
    appState.historyListKey = _key;

    return ShaderMask(
      shaderCallback: (bounds) => _maskingGradient.createShader(bounds),
      // This blend mode takes the opacity of the shader (i.e. our gradient)
      // and applies it to the destination (i.e. our animated list).
      blendMode: BlendMode.dstIn,
      child: AnimatedList(
        key: _key,
        reverse: true,
        padding: EdgeInsets.only(top: 100),
        initialItemCount: appState.history.length,
        itemBuilder: (context, index, animation) {
          final pair = appState.history[index];
          return SizeTransition(
            sizeFactor: animation,
            child: Center(
              child: TextButton.icon(
                onPressed: () {
                  appState.toggleFavorite(pair);
                },
                icon: appState.favorites.contains(pair)
                    ? Icon(Icons.favorite, size: 12)
                    : SizedBox(),
                label: Text(
                  pair.asLowerCase,
                  semanticsLabel: pair.asPascalCase,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
