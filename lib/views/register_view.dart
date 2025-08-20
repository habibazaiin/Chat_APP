import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/helper/show_snack_bar.dart';
import 'package:myapp/views/chat_view.dart';
import 'package:myapp/widgets/custom_button.dart';
import 'package:myapp/widgets/custom_text_form_field.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterView extends StatefulWidget {
  RegisterView({super.key});
  static String id = 'RegisterPage';

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  String? email;

  String? password;

  GlobalKey<FormState> globalKey = GlobalKey();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kBackGroundColor,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Form(
                key: globalKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 80),
                    Image.network(
                      kLogo,
                      height: 200,
                      width: 200,
                    ),
                    SizedBox(height: 52),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Register',
                        style: TextStyle(color: kPrimaryColor, fontSize: 30),
                      ),
                    ),
                    SizedBox(height: 15),
                    CustomTextFormField(
                      onChange: (value) {
                        email = value;
                      },
                      labelText: 'Email',
                      hintText: 'example@gmail.com',
                    ),
                    SizedBox(height: 8),
                    CustomTextFormField(
                      onChange: (value) {
                        password = value;
                      },
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                    ),
                    SizedBox(height: 42),
                    CustomButton(
                      onTap: () async {
                        if (globalKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await RegisterUser();
                            Navigator.pushNamed(context, ChatView.id, arguments: email);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'weak-password') {
                              ShowSnackBar(
                                context,
                                'The password provided is too weak.',
                              );
                            } else if (e.code == 'email-already-in-use') {
                              ShowSnackBar(
                                context,
                                'The account already exists for that email.',
                              );
                            }
                          } catch (e) {
                            ShowSnackBar(context, 'there was an error');
                          }
                          isLoading = false;
                          setState(() {});
                        }
                      },
                      text: 'Register',
                      color: kPrimaryColor,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'already have an account',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            '   Login',
                            style: TextStyle(color: Color(0xffF593F8)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> RegisterUser() async {
    UserCredential user = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email!, password: password!);
  }
}
