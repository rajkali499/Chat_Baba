import 'dart:io';

import 'package:chat_baba/bloc/auth_bloc/auth_bloc.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_event.dart';
import 'package:chat_baba/bloc/auth_bloc/auth_state.dart';
import 'package:chat_baba/helper/constants.dart';
import 'package:chat_baba/helper/dependency.dart';
import 'package:chat_baba/helper/nav_helper.dart';
import 'package:chat_baba/helper/utils.dart';
import 'package:chat_baba/model/request/create_user_request.dart';
import 'package:chat_baba/ui/components/cb_text_field.dart';
import 'package:chat_baba/ui/components/glassmorphism.dart';
import 'package:chat_baba/values/color_codes.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SignInPage extends StatelessWidget {
  SignInPage({super.key});

  ValueNotifier<bool> signUp = ValueNotifier(false);
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController emailField = TextEditingController();
  TextEditingController passwordField = TextEditingController();
  TextEditingController mobileNumber = TextEditingController();
  ValueNotifier<String> imageUrl = ValueNotifier("");

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) {
        disposeAllControllers();
      },
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthStateResponse>(
          listener: (context, state) {
            if (state.state == AuthState.authenticating) {
              showLoading(context);
            } else if(state.state == AuthState.authenticated){
              hideLoading();
              openScreen(dashboard,requiresAsInitial: true);
            }
            else {
              hideLoading();
            }
          },
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.black,
                child: Transform.scale(
                  scale: 2,
                  child: SvgPicture.asset(
                    assetsMap['bg_image'] ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: GlassMorphicContainer(
                  borderRadius: 20,
                  needIntrinsicHeight: true,
                  blur: 10,
                  alignment: Alignment.center,
                  border: 2,
                  color: Colors.white.withOpacity(0.1),
                  child: ValueListenableBuilder(
                      valueListenable: signUp,
                      builder: (context, bool signUpVal, _) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 500),
                                // Set the duration of the transition
                                transitionBuilder: (Widget child,
                                    Animation<double> animation) {
                                  final offsetAnimation = Tween<Offset>(
                                          begin: const Offset(1.0, 0.0),
                                          end: const Offset(0.0, 0.0))
                                      .animate(animation);
                                  return SlideTransition(
                                      position: offsetAnimation, child: child);
                                  // You can also use other transitions like SlideTransition, ScaleTransition, etc.
                                },
                                child: signUpVal
                                    ? buildSignUpView(context,
                                        key: const ValueKey('signUp'))
                                    : buildLoginView(context,
                                        key: const ValueKey('login')),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildLoginView(BuildContext context, {required ValueKey<String> key}) {
    return Container(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const FlutterLogo(
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              textMap["login"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              textMap["enter_your_email_and_password_to_login"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white70),
            ),
            const SizedBox(
              height: 20,
            ),
            CBTextField(
              fontsize: 12,
              textFontSize: 12,
              controller: email,
              floating: FloatingLabelBehavior.never,
              color: Colors.black,
              labelText: textMap["email"] ?? "",
              hintText: textMap["email"] ?? "",
              fillcolor: Colors.white,
              fill: true,
              borderRadius: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            CBTextField(
              fontsize: 12,
              textFontSize: 12,
              controller: password,
              floating: FloatingLabelBehavior.never,
              hintText: textMap["password"] ?? "",
              labelText: textMap["password"] ?? "",
              color: Colors.black,
              fillcolor: Colors.white,
              obscure: true,
              fill: true,
              borderRadius: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                getAuthBloc()?.add(
                    LoginEvent(email: email.text, password: password.text));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(textMap["log_in"] ?? "",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textMap["do_not_have_account"] ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    signUp.value = true;
                  },
                  child: Text(
                    textMap["sign_up"] ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: CBColors.amber),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSignUpView(BuildContext context,
      {required ValueKey<String> key}) {
    return Container(
      key: key,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const FlutterLogo(
              size: 50,
            ),
            const SizedBox(height: 10),
            Text(
              textMap["sign_up"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              textMap["create_an_account_to_continue"] ?? "",
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white70),
            ),
            const SizedBox(
              height: 20,
            ),
            ValueListenableBuilder(
              valueListenable: imageUrl,
              builder: (context, url,_) {
                return InkWell(
                  onTap: () {
                    selectImage();
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          child: Image.asset(url,errorBuilder: (context,obj,stackTrace){
                            return const FlutterLogo();
                          },),
                        ),
                        const Positioned(
                            bottom: 10, right: -2, child: Icon(Icons.camera_alt))
                      ],
                    ),
                  ),
                );
              }
            ),
            CBTextField(
              fontsize: 12,
              controller: name,
              textFontSize: 12,
              floating: FloatingLabelBehavior.never,
              color: Colors.black,
              labelText: textMap["name"] ?? "",
              hintText: textMap["name"] ?? "",
              fillcolor: Colors.white,
              fill: true,
              borderRadius: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            CBTextField(
              fontsize: 12,
              textFontSize: 12,
              controller: emailField,
              floating: FloatingLabelBehavior.never,
              color: Colors.black,
              labelText: textMap["email"] ?? "",
              hintText: textMap["email"] ?? "",
              fillcolor: Colors.white,
              fill: true,
              borderRadius: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            CBTextField(
              fontsize: 12,
              textFontSize: 12,
              controller: mobileNumber,
              floating: FloatingLabelBehavior.never,
              color: Colors.black,
              labelText: textMap["mobile_number"] ?? "",
              hintText: textMap["mobile_number"] ?? "",
              fillcolor: Colors.white,
              fill: true,
              borderRadius: 15,
              inputType: TextInputType.phone,
            ),
            const SizedBox(
              height: 20,
            ),
            CBTextField(
              fontsize: 12,
              textFontSize: 12,
              controller: passwordField,
              floating: FloatingLabelBehavior.never,
              hintText: textMap["password"] ?? "",
              labelText: textMap["password"] ?? "",
              color: Colors.black,
              fillcolor: Colors.white,
              obscure: true,
              fill: true,
              borderRadius: 15,
            ),
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                getAuthBloc()?.add(CreateUserEvent(
                    request: CreateUserRequest(
                        name: name.text,
                        email: emailField.text,
                        mobile: mobileNumber.text,
                        password: passwordField.text)));
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.amber,
                            borderRadius: BorderRadius.circular(20)),
                        child: Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(textMap["register"] ?? "",
                              textAlign: TextAlign.center,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                        )),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  textMap["already_have_an_account"] ?? "",
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge
                      ?.copyWith(color: Colors.white70),
                ),
                const SizedBox(
                  width: 10,
                ),
                InkWell(
                  onTap: () {
                    signUp.value = false;
                  },
                  child: Text(
                    textMap["log_in"] ?? "",
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: CBColors.amber),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  void disposeAllControllers() {
    password.dispose();
    email.dispose();
    emailField.dispose();
    passwordField.dispose();
    mobileNumber.dispose();
    name.dispose();
  }

  Future<void> selectImage() async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(type : FileType.image);

    if (result != null) {
      File file = File(result.files.single.path!);
      imageUrl.value = result.files.single.path??"";
    } else {
      // User canceled the picker
    }
  }
}
