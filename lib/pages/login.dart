import 'package:flutter/material.dart';
import '../common/styles/spacing_styles.dart';
import '../common/image_strings.dart';
import '../common/sizes.dart';
import '../common/ttexts.dart';

class LoginScreen extends StatelessWidget {
  //const LoginScreen({super.key});

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
                  Image(
                    height:150,
                    image:AssetImage(dark ? JImages.flag : JImages.flag),
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
                      prefixIcon: Icon(Icons.insert_comment),
                      labelText: TTexts.email,),
                  ),
                  const SizedBox(height: JSizes.spaceBtwItems),

                    /// Email
                  TextFormField(
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.settings_input_composite),
                      labelText: TTexts.password,
                      suffixIcon: Icon(Icons.settings_input_composite),
                      ),
                  ),
                  const SizedBox(height: JSizes.spaceBtwItems),  
               
                  /// remember me and forget password
                  Row(
                    children: [
                      // Remember Me
                      Row(
                        children: [
                          Checkbox(value: true, onChanged: (value){}),
                          const Text(TTexts.rememberMe),
                        ],
                      ),

                      // Forgot Password
                      TextButton(onPressed: (){}, child: const Text(TTexts.forgotPassword)),
                    ],
                  ),
                  const SizedBox(height: JSizes.spaceBtwItems),
               
                /// sign in button
                SizedBox(width: double.infinity, child: ElevatedButton(onPressed: (){}, child: Text(TTexts.signin))),
                SizedBox(width: double.infinity, child: OutlinedButton(onPressed: (){}, child: Text(TTexts.createAccount))),
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