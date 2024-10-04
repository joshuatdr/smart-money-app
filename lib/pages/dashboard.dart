import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);

    userID = jwtDecodedToken['user_id'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('Logged in as $userID')],
        ),
      ),
    );
  }
}
