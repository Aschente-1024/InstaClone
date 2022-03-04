import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:insta_clone/utils/text_input_util.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Login',
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: const Center(
        child: LoginForm(),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    log('loginscreen');
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Flexible(
            child: Container(),
            flex: 1,
          ),
          const SizedBox(
            height: 80,
            child: Text('Login', style: TextStyle(fontSize: 28)),
          ),
          TextInputUtil(
            controller: emailController,
            hintText: 'Email',
            validator: (value) =>
                EmailValidator.validate(value!) ? null : 'Enter Valid Email',
            obscureText: false,
          ),
          TextInputUtil(
            controller: passwordController,
            hintText: 'Password',
            obscureText: true,
          ),
          SizedBox(
            width: 320,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        context
                            .read<UserProvider>()
                            .forgotPassword(emailController.text);
                      }
                    },
                    child: const Text('Forgot Password?'))
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<UserProvider>().loginUser(
                    emailController.value.text, passwordController.value.text);
              }
            },
            child: const Text('Login'),
          ),
          Flexible(
            child: Container(),
            flex: 1,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 16.0),
                child: Text('Dont have account?'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/signup');
                  },
                  child: const Text('Sign Up')),
            ],
          ),
        ],
      ),
    );
  }
}
