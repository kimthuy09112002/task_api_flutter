import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:task_api_flutter/components/button/td_elevated_button.dart';
import 'package:task_api_flutter/components/text_field/td_text_field.dart';
import 'package:task_api_flutter/components/text_field/td_text_field_password.dart';
import 'package:task_api_flutter/pages/auth/register_page.dart';
import 'package:task_api_flutter/resources/app_color.dart';
import 'package:task_api_flutter/services/remote/auth_services.dart';
import 'package:task_api_flutter/services/remote/body/login_body.dart';
import 'package:task_api_flutter/utils/validator.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.email});

  final String? email;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    emailController.text = widget.email ?? '';
  }

  Future<void> _submitLogin() async {
    if (formKey.currentState!.validate() == false) {
      return;
    }

    isLoading = true;
    setState(() {});
    await Future.delayed(const Duration(milliseconds: 1200));

    AuthServices()
        .login(LoginBody()
          ..email = emailController.text.trim()
          ..password = passwordController.text)
        .then((response) {
      final data = jsonDecode(response.body);
      if (data['status_code'] == 200) {
        final token = data['body']['token'];
        // SharedPrefs.token = token;
        print('object token $token');
        isLoading = false;
        setState(() {});
        // Navigator.of(context).pushAndRemoveUntil(
        //   MaterialPageRoute(
        //     builder: (context) => const MainPage(title: 'Tasks'),
        //   ),
        //   (Route<dynamic> route) => false,
        // );
      } else {
        print('object message ${data['message']}');
        isLoading = false;
        setState(() {});
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0)
                .copyWith(top: 80.0, bottom: 72.0),
            children: [
              const Center(
                child: Text(
                  'Login',
                  style: TextStyle(color: AppColor.red, fontSize: 26.0),
                ),
              ),
              const SizedBox(height: 46.0),
              TdTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email, color: Colors.orange),
                validator: Validator.emailValidator,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: 20.0),
              TdTextFieldPassword(
                controller: passwordController,
                hintText: 'Password',
                validator: Validator.passwordValidator,
                onFieldSubmitted: (_) => _submitLogin(),
                textInputAction: TextInputAction.done,
              ),
              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const RegisterPage(),
                    )),
                    child: const Text(
                      'Register',
                      style: TextStyle(color: AppColor.red, fontSize: 16.0),
                    ),
                  ),
                  const Text(
                    ' | ',
                    style: TextStyle(color: AppColor.orange, fontSize: 16.0),
                  ),
                  GestureDetector(
                    // onTap: () =>
                    //     Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context) => const ForgotPasswordPage(),
                    // )),
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(color: AppColor.brown, fontSize: 16.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 60.0),
              TdElevatedButton.outline(
                onPressed: () => _submitLogin(),
                text: 'Login',
                isDisable: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
