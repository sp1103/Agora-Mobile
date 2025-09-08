import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';

class LogIn extends StatefulWidget{
  const LogIn({super.key});
  
  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {

  final _formkey = GlobalKey<FormState>(); 
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        title: Text("Log In To Agora"), 
        centerTitle: true
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextFormField(
                  validator: MultiValidator([
                    RequiredValidator(errorText: "Please Enter Email"),
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
                child: Text("ya"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}