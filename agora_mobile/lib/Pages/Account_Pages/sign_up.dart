import 'package:agora_mobile/Pages/Account_Pages/log_in.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:provider/provider.dart';
import 'package:agora_mobile/app_state.dart';

class SignUp extends StatefulWidget{
  const SignUp({super.key});
  
  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final _formkey = GlobalKey<FormState>(); 
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {

    var appState = context.watch<AgoraAppState>();

    return Scaffold(
      appBar:  AppBar(
        title: Text("Sign Up To Agora"), 
        centerTitle: true
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _emailController,
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Please enter Email"),
                    EmailValidator(errorText: "Please enter a valid email"),
                  ]).call,
                  decoration: InputDecoration(
                    labelText: "Email",
                    hintText: "Please Enter Your Email",
                    errorStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  validator: RequiredValidator(errorText: "Please enter password").call,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Please Enter Your Password",
                    errorStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.all(Radius.circular(9.0)),
                    ),
                  ),
                ),
              ),
              Align(alignment: Alignment.centerLeft, child: TextButton(onPressed: () {appState.openSignUpOrLogin(LogIn());}, child: Text("Log In"))),
              Padding(
                padding: const EdgeInsets.all(28.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formkey.currentState!.validate()) {
                      await appState.signUp(_emailController.text.trim(), _passwordController.text.trim());
                    }
                  }, 
                  child: Text("Sign Up"))
              )
            ],
          ),
        ),
      ),
    );
  }
  
}