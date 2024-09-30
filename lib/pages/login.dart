import 'package:flutter/material.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import '../common/ttexts.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //const LoginScreen({super.key});
   bool isChecked = false;

var dark = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child:Padding(
          padding:JSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title & Sub Title
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 50, right: 50, top: 10, bottom: 50),
                    child: Image(

                      image:AssetImage(dark ? JImages.flag : JImages.flag),
                    ),
                  ),
                  Text(TTexts.loginTitle, style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: JSizes.sm,),
                  Text(TTexts.loginSubTitle, style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),

              /// Form
              Form(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: JSizes.spaceBtwItems),
              child: Column(
                children: [
                  /// Email
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: TTexts.email,),
                  ),
                  const SizedBox(height: JSizes.spaceBtwItems),

                    /// Password
                  TextFormField(
                     obscureText:true,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.login),
                      labelText: TTexts.password,
                      ),
                  ),
                  const SizedBox(height: JSizes.spaceBtwItems),  
               
                  /// remember me and forget password
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Remember Me
                      Row(
                        children: [
                          Checkbox(value: isChecked, onChanged: (bool? value){
                            setState(() {
                              isChecked = value!;
                            });
                          }),
                          const Text(TTexts.rememberMe),
                        ],
                      ),

                      // Forgot Password
                      TextButton(onPressed: (){}, child: const Text(TTexts.forgotPassword)),
                    ],
                  ),
                  const SizedBox(height: JSizes.spaceBtwItems),
               
                /// sign in button
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(width: double.infinity,
                  child: ElevatedButton(style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), 
                             textStyle: TextStyle(foreground: Paint()..color = Colors.white, fontSize: 20,fontWeight: FontWeight.bold)
                             ), 
                             onPressed: (){}, child: Text(TTexts.signin))),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(width: double.infinity, 
                  child: OutlinedButton(style: ElevatedButton.styleFrom(
                             backgroundColor: Colors.orange, padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20), 
                             textStyle: TextStyle(foreground: Paint()..color = Colors.white, fontSize: 20,fontWeight: FontWeight.bold)
                             ), 
                            onPressed: (){}, child: Text(TTexts.createAccount))),
                ),
                ],
              ),
              ),
              ),//
            
            ],
          ),
        ),
          ),
        );
  }
}