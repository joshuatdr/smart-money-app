import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/user.dart';

// This class sends the get request from the endpoint

class UserServices {
  String baseUrl = "https://smart-money-backend.onrender.com/api/user/1";      // create a variable String to store the API Base URL

  getAllUserData() async {                    // create an asynchronous function 
    List<User> allUsers = [];             // create an array of type <Employee> from employee.dart called allEmployees
    try {                                         // try, catch - error handling, very similar to then and catch in JavaScript
      var response = await http.get(Uri.parse(baseUrl)); // You can use the await keyword to get the completed result of an asynchronous expression. The await keyword only works within an async function.
      if (response.statusCode == 200) {
        var data = response.body;                 
        var decodedData = jsonDecode(data);       // jsonDecode Parses the string and returns the resulting Json object.
        var users = decodedData['user'];      // employees is an array of objects [{}{}{}]

//User newUser = User.fromJson(users);
//allUsers.add(newUser);

        print(users);
        print(users['email']);    
       // User newUser = User.fromJson(users);
//print(allUsers);


                                 // prints data to console
return users;

       // for(var user in users){             // iterate through employees
       //   User newUser = User.fromJson(users); // The Employee.fromJson is a method from the Class Employee in employee.dart is used to create a Dart object from a JSON data structure
      //    allUsers.add(newUser);
       // }
      //  print(allUsers);
     //   return allUsers;            
      }
    } catch (e) {
      print(e);
      throw Exception(e.toString());            // if error convert error to a string.
    }
  }
}
