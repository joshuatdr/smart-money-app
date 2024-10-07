import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_money_app/pages/auth/signup.dart';
import 'package:smart_money_app/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'pages/dashboard/dashboard.dart';
import 'package:english_words/english_words.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.getString('token');
  token ??=
      "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoxLCJpYXQiOjE3MjgwMzM4MDIsImV4cCI6MTcyODAzMzg2Mn0.PliYS6OJHCHD8XurFLYmFwMxEgCtt7224W8kemVm2ss"; // app will crash if token is null, need to fix
  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String token;

  const MyApp({
    required this.token,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(),
        ),
        ChangeNotifierProvider(create: (context) => MyAppState()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Money',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              //change this to change the general theme of the app
              // Color.fromARGB(255, 59, 17, 107)),
              seedColor: Colors.lightBlue.shade900),
        ),
        home: (JwtDecoder.isExpired(token) == false)
            ? Dashboard(token: token, firstLogin: false)
            : SignupScreen(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();
  var history = <WordPair>[];

  GlobalKey? historyListKey;

  void getNext() {
    history.insert(0, current);
    var animatedList = historyListKey?.currentState as AnimatedListState?;
    animatedList?.insertItem(0);
    current = WordPair.random();
    notifyListeners();
  }

  var budget = 0;
  var goals = [];
  var favorites = <WordPair>[];

  void toggleFavorite([WordPair? pair]) {
    pair = pair ?? current;
    if (favorites.contains(pair)) {
      favorites.remove(pair);
    } else {
      favorites.add(pair);
    }
    notifyListeners();
  }

  void removeFavorite(WordPair pair) {
    favorites.remove(pair);
    notifyListeners();
  }
}
