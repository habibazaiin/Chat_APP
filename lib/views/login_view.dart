import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:myapp/constants.dart';
import 'package:myapp/helper/show_snack_bar.dart';
import 'package:myapp/views/chat_view.dart';
import 'package:myapp/views/cubits/login_cubit/login_cubit.dart';
import 'package:myapp/views/register_view.dart';
import 'package:myapp/widgets/custom_button.dart';
import 'package:myapp/widgets/custom_text_form_field.dart';

class LoginView extends StatelessWidget {
  GlobalKey<FormState> globalKey = GlobalKey();
  static String id = 'LoginPage';

  bool isLoading = false;
  String? email, password;

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginLoading) {
          isLoading = true;
        } else if (state is LoginFailure) {
          ShowSnackBar(context, state.errMessage);
          isLoading = false;
        } else if (state is LoginSucess) {
          Navigator.pushNamed(context, ChatView.id, arguments: email,);
          isLoading = false;
        }
      },
      child: ModalProgressHUD(
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
                      Image.network(kLogo, height: 200, width: 200),
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

                          if (globalKey.currentState!.validate()) {
                            BlocProvider.of<LoginCubit>(
                              context,
                            ).SignInUser(email: email!, password: password!);
                          }
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
      ),
    );
  }

  
}
