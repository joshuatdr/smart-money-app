import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_money_app/model/goals.dart';
import '../model/user.dart';
import '../model/transactions.dart';

// This class sends the get request from the endpoint

class UserServices {
  String bbaseUrl =
      "https://smart-money-backend.onrender.com/api/login/jimmy4000@gmail.com"; // create a variable String to store the API Base URL

  getUserId() async {
    // create an asynchronous function

    //List<User> allUsers =
       // []; // create an array of type <Employee> from employee.dart called allEmployees

    try {
      // try, catch - error handling, very similar to then and catch in JavaScript
      var response = await http.get(Uri.parse(
          bbaseUrl)); // You can use the await keyword to get the completed result of an asynchronous expression. The await keyword only works within an async function.
      if (response.statusCode == 200) {
        var data = response.body;

        // print(data);

        var decodedData = jsonDecode(
            data); // jsonDecode Parses the string and returns the resulting Json object.
        var users =
            decodedData['user_id']; // employees is an array of objects [{}{}{}]

        // print(users);
        // print(users['user_id']);

        //   User newUser = User.fromJson(
        //      users); // The Employee.fromJson is a method from the Class Employee in employee.dart is used to create a Dart object from a JSON data structure
        // allUsers.add(newUser);

        //  print(allUsers);
        return users;
      }
    } catch (e) {
      print(e);
      print("error");
      //throw Exception(e.toString()); // if error convert error to a string.
    }
  }

  getAllUserData(userID) async {
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userID"; // create a variable String to store the API Base URL
    // create an asynchronous function
    List<User> allUsers =
        []; // create an array of type <Employee> from employee.dart called allEmployees
    try {
      // try, catch - error handling, very similar to then and catch in JavaScript
      var response = await http.get(Uri.parse(
          baseUrl)); // You can use the await keyword to get the completed result of an asynchronous expression. The await keyword only works within an async function.
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(
            data); // jsonDecode Parses the string and returns the resulting Json object.
        var users =
            decodedData['user']; // employees is an array of objects [{}{}{}]

//User newUser = User.fromJson(users);
//allUsers.add(newUser);

        // print(users);
        // print(users['email']);
        // User newUser = User.fromJson(users);
//print(allUsers);

        // prints data to console
// return users;

        // for (var user in users) {
        //   // iterate through employees
        //   User newUser = User.fromJson(
        //       user); // The Employee.fromJson is a method from the Class Employee in employee.dart is used to create a Dart object from a JSON data structure
        //   allUsers.add(newUser);

        //   print(allUsers);
        //   return allUsers;
        // }
        User newUser = User.fromJson(
            users); // The Employee.fromJson is a method from the Class Employee in employee.dart is used to create a Dart object from a JSON data structure
        allUsers.add(newUser);

        // print(allUsers);
        return allUsers;
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString()); // if error convert error to a string.
    }
  }

  getAllUserTransactions(userID) async {
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userID/transactions";

    // create an asynchronous function
    List<Transactions> allTransactions =
        []; // create an array of type <Employee> from employee.dart called allEmployees
    try {
      // try, catch - error handling, very similar to then and catch in JavaScript
      var response = await http.get(Uri.parse(
          baseUrl)); // You can use the await keyword to get the completed result of an asynchronous expression. The await keyword only works within an async function.
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(
            data); // jsonDecode Parses the string and returns the resulting Json object.
        var transactions = decodedData[
            'transactions']; // employees is an array of objects [{}{}{}]

//User newUser = User.fromJson(users);
//allUsers.add(newUser);

        //   print(transactions);
        // print(users['email']);
        // User newUser = User.fromJson(users);
//print(allUsers);

        // prints data to console
// return users;

        for (var transaction in transactions) {
          // iterate through employees
          Transactions newTransaction = Transactions.fromJson(
              transaction); // The Employee.fromJson is a method from the Class Employee in employee.dart is used to create a Dart object from a JSON data structure
          allTransactions.add(newTransaction);
        }

        // print(allTransactions);
        return allTransactions;

/*
        User newUser = User.fromJson(
            users); // The Employee.fromJson is a method from the Class Employee in employee.dart is used to create a Dart object from a JSON data structure
        allUsers.add(newUser);

        print(allUsers);
        return allUsers;*/
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString()); // if error convert error to a string.
    }
  }

  postUserTransaction(data, apiUrl) async {
    var userId = data['user_id'];
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userId/$apiUrl";


    return await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  getAllUserGoals(userID) async {
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userID/goals";

    List<Goals> allGoals = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        var goals = decodedData['goals'];

        for (var goal in goals) {
          Goals newGoal = Goals.fromJson(goal);
          allGoals.add(newGoal);
        }
        return allGoals;
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());
    }
  }

  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
