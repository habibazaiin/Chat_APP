import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/helper/show_snack_bar.dart';
import 'package:myapp/views/chat_view.dart';
import 'package:myapp/views/register_view.dart';
import 'package:myapp/widgets/custom_button.dart';
import 'package:myapp/widgets/custom_text_form_field.dart';

class LoginView extends StatefulWidget {
  LoginView({super.key});
  static String id = 'LoginPage';

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  GlobalKey<FormState> globalKey = GlobalKey();

  bool isLoading = false;
  String? email, password;

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
                    const SizedBox(height: 52),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Login',
                        style: TextStyle(color: kPrimaryColor, fontSize: 30),
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomTextFormField(
                      onChange: (value) {
                        email = value;
                      },
                      labelText: 'Email',
                      hintText: 'example@gmail.com',
                    ),
                    const SizedBox(height: 8),
                    CustomTextFormField(
                      onChange: (value) {
                        password = value;
                      },
                      labelText: 'Password',
                      hintText: 'Enter your password',
                      obscureText: true,
                    ),
                    const SizedBox(height: 42),
                    CustomButton(
                      onTap: () async {
                        isLoading = true;
                        setState(() {});
                        if (globalKey.currentState!.validate()) {
                          try {
                            await SignInUser();
                            Navigator.pushNamed(context, ChatView.id, arguments: email);
                          } on FirebaseAuthException catch (e) {
                            if (e.code == 'user-not-found') {
                              ShowSnackBar(
                                context,
                                'No user found for that email.',
                              );
                            } else if (e.code == 'wrong-password') {
                              ShowSnackBar(
                                context,
                                'Wrong password provided for that user.',
                              );
                            }
                          } catch (e) {
                            ShowSnackBar(context, 'there was an error, try later');
                          }
                        }
                        isLoading = false;
                        setState(() {
                          
                        });
                      },
                      text: 'Login',
                      color: kPrimaryColor,
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'don\'t have an account',
                          style: TextStyle(color: kPrimaryColor),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, RegisterView.id);
                          },
                          child: const Text(
                            '   Register',
                            style: TextStyle(color: Color(0xffF593F8)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> SignInUser() async {
    UserCredential user = await FirebaseAuth.instance
        .signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
  }
}
