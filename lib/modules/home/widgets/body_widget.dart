import 'package:flutter/material.dart';
import 'package:thermal_printer/core/models/user_information.dart';

import 'package:thermal_printer/modules/home/controller/controller.dart';

class BodyWidget extends StatefulWidget {
  final String title;
  final bool isAndroid;

  const BodyWidget({
    super.key,
    required this.title,
    this.isAndroid = false,
  });

  @override
  State<BodyWidget> createState() => _BodyWidgetState();
}

class _BodyWidgetState extends State<BodyWidget> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  UserInformation userInformation = UserInformation();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.indigoAccent,
          title: Text(widget.title),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter user information",
                  style: TextStyle(fontSize: 20.0),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: "Name",
                  ),
                  onSaved: (value) {
                    userInformation = userInformation.copyWith(name: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a name";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Email",
                  ),
                  onSaved: (value) {
                    userInformation = userInformation.copyWith(email: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter an email";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone",
                  ),
                  onSaved: (value) {
                    userInformation = userInformation.copyWith(phone: value);
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter a phone number";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.indigoAccent,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      final result =
                          await Controller.printDocument(userInformation);
                      print(result);
                    }
                  },
                  child: const Text("Print"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
