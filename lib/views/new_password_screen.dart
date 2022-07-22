import 'package:flutter/material.dart';
import 'package:meal_monkey/responsive/base_widget.dart';
import 'package:meal_monkey/responsive/device_info.dart';
import 'package:meal_monkey/views/login_screen.dart';
import 'package:meal_monkey/views/onbording_screen.dart';
import 'package:meal_monkey/widgets/button.dart';
import 'package:meal_monkey/widgets/custom_widget.dart';
import 'package:meal_monkey/widgets/textField.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NewPassword extends StatefulWidget {
  static String id = '/new-password-screen';

  NewPassword({Key? key}) : super(key: key);

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final _key = GlobalKey<FormState>();

  final _passwordController = TextEditingController();

  final _confPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BaseWidget(
      builder: (context, deviceInfo) => SafeArea(
        child: Scaffold(
          body: SizedBox(
            width: deviceInfo.screenSize.width,
            child: Form(
              key: _key,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  buildHeaderText(
                      title: "New Password",
                      description:
                          "Please enter your email to receive a \nlink to  create a new password via email"),
                  _buildUserInput(deviceInfo),
                  const SizedBox(height: 20),
                  _buildLoginButton(context, deviceInfo),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserInput(DeviceInfo deviceInfo) {
    return Column(
      children: [
        MyTextField(
            deviceInfo: deviceInfo,
            hintText: 'Password',
            controller: _passwordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'password is required';
              }

              final password = _passwordController.text;
              if (password.length < 8) {
                return 'password must be more than 8 charachters';
              }
            },
            obscure: true),
        const SizedBox(height: 20),
        MyTextField(
            deviceInfo: deviceInfo,
            hintText: 'Coniform Password',
            controller: _confPasswordController,
            validator: (value) {
              if (value!.isEmpty) {
                return 'password is required';
              }

              if (_confPasswordController.text != _passwordController.text) {
                return 'Passwords do not match';
              }
            },
            obscure: true),
      ],
    );
  }

  Future<void> _validate() async {
    final form = _key.currentState;
    if (!form!.validate()) {
      return;
    }

    SharedPreferences preferences = await SharedPreferences.getInstance();
    final password = preferences.get('password');
    preferences.setString('password', _passwordController.text.trim());

    Navigator.of(context).pushReplacementNamed(LoginScreen.id);

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('password change successful')));
  }

  Widget _buildLoginButton(BuildContext context, DeviceInfo deviceInfo) {
    return MyButton(
      onPressed: _validate,
      widget: const Text('Next'),
      color: const Color(0xffFC6011),
      deviceInfo: deviceInfo,
    );
  }
}