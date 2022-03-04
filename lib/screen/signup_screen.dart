import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/utils/text_input_util.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Sign Up',
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: const Center(
        child: SignupForm(),
      ),
    );
  }
}

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  File? _image;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final passwordConfirmController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();

  pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    log('signupscreen');
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
            child: Text('Signup', style: TextStyle(fontSize: 28)),
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
          TextInputUtil(
            controller: passwordConfirmController,
            hintText: 'Confirm Password',
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                context.read<UserProvider>().createNewUser(
                    emailController.text, passwordController.text);
                Navigator.pushReplacementNamed(context, '/');
              }
            },
            child: const Text('Sign up'),
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
                child: Text('Already have account?'),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: const Text('Log In')),
            ],
          ),
        ],
      ),
    );
  }
}
