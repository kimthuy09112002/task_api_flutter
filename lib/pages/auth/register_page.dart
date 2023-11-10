import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:task_api_flutter/components/button/td_elevated_button.dart';
import 'package:task_api_flutter/components/text_field/td_text_field.dart';
import 'package:task_api_flutter/components/text_field/td_text_field_password.dart';
import 'package:task_api_flutter/constants/app_constant.dart';
import 'package:task_api_flutter/gen/assets.gen.dart';
import 'package:task_api_flutter/pages/auth/verification_code_page.dart';
import 'package:task_api_flutter/resources/app_color.dart';
import 'package:task_api_flutter/services/remote/auth_services.dart';
import 'package:task_api_flutter/services/remote/body/register_body.dart';
import 'package:task_api_flutter/utils/validator.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  String? avatar;
  File? fileAvatar;

  bool isLoadingAvatar = false;

  final formKey = GlobalKey<FormState>();

  Future<http.Response> postFile2(String url, File file) async {
    // String? token = SharedPrefs.token;
    final request = http.MultipartRequest('POST', Uri.parse(url));

    request.files.addAll([
      await http.MultipartFile.fromPath('file', file.path),
    ]);
    request.headers.addAll({
      'Content-Type': 'multipart/form-data',
      'Accept': 'application/json',
      'Authorization': 'Bearer ${null}',
    });

    final stream = await request.send();

    final response = http.Response.fromStream(stream).then((response) {
      if (response.statusCode == 200) {
        // print('response ${response.body}');
        return response;
      }
      throw Exception('Failed to load data');
    });

    return response;
  }

  Future<String?> uploadFile(File file) async {
    const url = AppConstant.endPointUploadFile;
    http.Response response = await postFile2(url, file);
    Map<String, dynamic> result = jsonDecode(response.body);
    // print('object $result');

    return result['body']['file'];
  }

  Future<String?> uploadAvatar() async {
    if (fileAvatar == null) return null;
    String? value;
    await uploadFile(fileAvatar!).then((response) {
      value = response;
    }).catchError((onError) {
      print('$onError');
      return null;
    });
    return value;
  }

  Future<void> pickAvatar() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );
    if (result == null) return;
    fileAvatar = File(result.files.single.path!);
    isLoadingAvatar = true;
    setState(() {});
    avatar = await uploadAvatar();
    await Future.delayed(const Duration(milliseconds: 2600));
    isLoadingAvatar = false;
    setState(() {});
    print('object ${avatar!}');
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
                  'Register',
                  style: TextStyle(color: AppColor.red, fontSize: 26.0),
                ),
              ),
              const SizedBox(height: 32.0),
              Center(
                child: GestureDetector(
                  onTap: pickAvatar,
                  child: Stack(
                    children: [
                      isLoadingAvatar
                          ? CircleAvatar(
                              radius: 34.6,
                              backgroundColor: Colors.orange.shade200,
                              child: const SizedBox.square(
                                dimension: 36.0,
                                child: CircularProgressIndicator(
                                  color: AppColor.pink,
                                  strokeWidth: 2.6,
                                ),
                              ),
                            )
                          : CircleAvatar(
                              radius: 34.6,
                              backgroundImage: fileAvatar == null
                                  // ? Assets.images.defaultAvatar.provider()
                                  ? AssetImage(Assets.images.defaultAvatar.path)
                                      as ImageProvider
                                  : FileImage(
                                      File(fileAvatar?.path ?? ''),
                                    ),
                            ),
                      Positioned(
                        right: 0.0,
                        bottom: 0.0,
                        child: Container(
                          padding: const EdgeInsets.all(4.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.pink)),
                          child: const Icon(
                            Icons.camera_alt_outlined,
                            size: 14.6,
                            color: AppColor.pink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 42.0),
              TdTextField(
                controller: nameController,
                hintText: 'Full Name',
                prefixIcon: const Icon(Icons.person, color: AppColor.orange),
                textInputAction: TextInputAction.next,
                validator: Validator.requiredValidator,
              ),
              const SizedBox(height: 20.0),
              TdTextField(
                controller: emailController,
                hintText: 'Email',
                prefixIcon: const Icon(Icons.email, color: AppColor.orange),
                textInputAction: TextInputAction.next,
                validator: Validator.emailValidator,
              ),
              const SizedBox(height: 20.0),
              TdTextFieldPassword(
                controller: passwordController,
                hintText: 'Password',
                textInputAction: TextInputAction.next,
                validator: Validator.passwordValidator,
              ),
              const SizedBox(height: 20.0),
              TdTextFieldPassword(
                controller: confirmPasswordController,
                onChanged: (_) => setState(() {}),
                hintText: 'Confirm Password',
                textInputAction: TextInputAction.done,
                validator:
                    Validator.confirmPasswordValidator(passwordController.text),
              ),
              const SizedBox(height: 60.0),
              TdElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    AuthServices()
                        .sendOtp(emailController.text.trim())
                        .then((response) {
                      final data = jsonDecode(response.body);
                      if (data['status_code'] == 200) {
                        print('object code ${data['body']['code']}');
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => VerificationCodePage(
                              registerBody: RegisterBody()
                                ..name = nameController.text.trim()
                                ..email = emailController.text.trim()
                                ..password = passwordController.text
                                ..avatar = avatar,
                            ),
                          ),
                        );
                      } else {
                        print('object message ${data['message']}');
                      }
                    });
                  }
                },
                text: 'Sign up',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
