import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smart_money_app/model/goals.dart';
import 'package:smart_money_app/model/expenses.dart';
import 'package:smart_money_app/model/transactions.dart';
import 'package:smart_money_app/model/user.dart';

// This class sends the get request from the endpoint

class UserServices {
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

  patchUserTransaction(data, apiUrl) async {
    //var userId = data['user_id'];
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$apiUrl";

    //"PATCH /api/user/:user_id/transactions/:transaction_id": {

    // print(baseUrl);
    return await http.patch(
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

  getUserGoal(userID, goalId) async {
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userID/goals/$goalId"; // create a variable String to store the API Base URL
    // create an asynchronous function
   List<Goals> allGoals = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        var goals = decodedData['goals'];

print(goals); 

        for (var goal in goals) {
          Goals newGoal = Goals.fromJson(goal);
          allGoals.add(newGoal);
        }
        print(allGoals);
        return allGoals;
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString()); // if error convert error to a string.
    }
  }

  postUserGoal(data) async {
    var userID = data['user_id'];
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userID/goals";

    return await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  patchUserGoal(data, apiUrl) async {
    //var userID = data['user_id'];
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$apiUrl";

    return await http.patch(
      Uri.parse(baseUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  deleteUserGoal(apiUrl) async {
    //  var userID = data['user_id'];
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$apiUrl";

    return await http.delete(Uri.parse(baseUrl));
  }

  postExpense(data) async {
    var userID = data['user_id'];
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userID/expenses";

    return await http.post(
      Uri.parse(baseUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }

  static getAllUserExpenses(userID) async {
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userID/expenses";
    List<Expenses> allExpenses = [];
    try {
      var response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        var data = response.body;
        var decodedData = jsonDecode(data);
        var expenses = decodedData['expenses'];

        for (var expense in expenses) {
          Expenses newExpense = Expenses.fromJson(expense);
          allExpenses.add(newExpense);
        }
        return allExpenses;
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString()); // if error convert error to a string.
    }
  }


patchUser(data, userId) async {
   //var userID = data['user_id'];
    String baseUrl =
        "https://smart-money-backend.onrender.com/api/user/$userId";

    return await http.patch(
      Uri.parse(baseUrl),
      body: jsonEncode(data),
      headers: _setHeaders(),
    );
  }



  _setHeaders() => {
        'Content-type': 'application/json',
        'Accept': 'application/json',
      };
}
