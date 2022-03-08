import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:insta_clone/providers/user_provider.dart';
import 'package:insta_clone/utils/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:provider/provider.dart';
import 'package:insta_clone/utils/text_input_util.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Details',
          style: TextStyle(fontSize: 22),
        ),
        centerTitle: true,
      ),
      drawer: const Drawer(),
      body: const Center(
        child: DetailForm(),
      ),
    );
  }
}

class DetailForm extends StatefulWidget {
  const DetailForm({Key? key}) : super(key: key);

  @override
  _DetailFormState createState() => _DetailFormState();
}

class _DetailFormState extends State<DetailForm> {
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final userName = TextEditingController();
  final bio = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  File? image;

  final DateRangePickerController datePick = DateRangePickerController();
  String _selectedDate = '';

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    setState(() {
      if (args.value is DateTime) {
        _selectedDate = DateFormat('dd/MM/yyyy').format(args.value);
      }
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select BirthDate'),
          content: SizedBox(
              height: 300,
              width: 200,
              child: SfDateRangePicker(
                view: DateRangePickerView.month,
                selectionMode: DateRangePickerSelectionMode.single,
                onSelectionChanged: _onSelectionChanged,
                showActionButtons: true,
                onSubmit: (Object? value) {
                  Navigator.of(context).pop();
                },
                onCancel: () {
                  Navigator.of(context).pop();
                },
              )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log('UserDetail');
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Flexible(
            child: Container(),
            flex: 1,
          ),
          GestureDetector(
            onTap: () async {
              String? pickedFile = await pickImage(ImageSource.gallery);
              if (pickedFile != null) {
                setState(() {
                  image = File(pickedFile);
                });
              }
            },
            child: CircleAvatar(
              foregroundImage: image == null
                  ? const NetworkImage(
                      'http://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png')
                  : Image.file(image!).image,
              radius: 40,
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: 160,
                child: TextInputUtil(
                  controller: firstName,
                  hintText: 'First Name',
                  validator: (value) => EmailValidator.validate(value!)
                      ? null
                      : 'Enter Valid Email',
                  obscureText: false,
                ),
              ),
              SizedBox(
                width: 160,
                child: TextInputUtil(
                  controller: lastName,
                  hintText: 'Last Name',
                ),
              ),
            ],
          ),
          TextInputUtil(
            controller: userName,
            hintText: 'User Name',
          ),
          TextInputUtil(
            controller: bio,
            hintText: 'Bio',
            maxLines: 3,
          ),
          ElevatedButton(
            onPressed: () async {
              await _showMyDialog();
              log('selected date $_selectedDate');
            },
            child: _selectedDate == ''
                ? const Text('Select Birth Date')
                : Text(_selectedDate),
          ),
          ElevatedButton(
            onPressed: () {
              // if (_formKey.currentState!.validate()) {
              //   context.read<UserProvider>().loginUser(
              //       emailController.value.text, passwordController.value.text);
              // }
              context.read<UserProvider>().updateUserOnFirestore(
                    firstName: firstName.text,
                    lastName: lastName.text,
                    userName: userName.text,
                    bio: bio.text,
                    dateOfBirth: _selectedDate,
                  );
              print(_selectedDate);
              print(context.read<UserProvider>().getCurrentUser);
            },
            child: const Text('Save'),
          ),
          Flexible(
            child: Container(),
            flex: 1,
          ),
        ],
      ),
    );
  }
}
