import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:task_api_flutter/components/button/td_elevated_button.dart';
import 'package:task_api_flutter/pages/auth/login_page.dart';
import 'package:task_api_flutter/resources/app_color.dart';
import 'package:task_api_flutter/services/remote/auth_services.dart';
import 'package:task_api_flutter/services/remote/body/register_body.dart';

class VerificationCodePage extends StatefulWidget {
  const VerificationCodePage({super.key, required this.registerBody});

  final RegisterBody registerBody;

  @override
  State<VerificationCodePage> createState() => _VerificationCodePageState();
}

class _VerificationCodePageState extends State<VerificationCodePage> {
  TextEditingController verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0)
              .copyWith(top: 80.0, bottom: 72.0),
          children: [
            const Center(
              child: Text(
                'Enter Verification Code',
                style: TextStyle(color: Colors.red, fontSize: 24.0),
              ),
            ),
            const SizedBox(height: 46.0),
            PinCodeTextField(
              controller: verificationCodeController,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              appContext: context,
              textStyle: const TextStyle(color: Colors.red),
              length: 4,
              cursorColor: Colors.orange,
              cursorHeight: 16.0,
              cursorWidth: 2.0,
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8.6),
                fieldHeight: 46.0,
                fieldWidth: 40.0,
                activeFillColor: Colors.red,
                inactiveColor: Colors.orange,
                activeColor: Colors.red,
                selectedColor: Colors.orange,
              ),
              scrollPadding: EdgeInsets.zero,
              onChanged: (_) {},
              onCompleted: (value) {
                verificationCodeController.text = value;
                setState(() {});
              },
            ),
            const SizedBox(height: 6.0),
            Center(
              child: RichText(
                text: TextSpan(
                  text: 'You didn\'t receive the pin code? ',
                  style: const TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Resend',
                      style: TextStyle(color: AppColor.red.withOpacity(0.86)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          AuthServices()
                              .sendOtp(widget.registerBody.email!)
                              .then((response) {
                            final data = jsonDecode(response.body);
                            if (data['status_code'] == 200) {
                              print('object code ${data['body']['code']}');
                            } else {
                              print('object message ${data['message']}');
                            }
                          });
                        },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 90.0),
            TdElevatedButton.outline(
              onPressed: () {
                AuthServices()
                    .register(widget.registerBody
                      ..code = verificationCodeController.text)
                    .then((response) {
                  final data = jsonDecode(response.body);
                  if (data['status_code'] == 200) {
                    print('object register success ${data['body']['email']}');
                    Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) =>
                            LoginPage(email: widget.registerBody.email),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    print('object message ${data['message']}');
                  }
                });
              },
              text: 'Done',
            ),
          ],
        ),
      ),
    );
  }
}
