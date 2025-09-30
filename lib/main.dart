import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/views/chat_view.dart';
import 'package:myapp/views/cubits/login_cubit/login_cubit.dart';
import 'package:myapp/views/cubits/register_cubit/register_cubit.dart';
import 'package:myapp/views/login_view.dart';
import 'package:myapp/views/register_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
      ],
      child: MaterialApp(
        routes: {
          LoginView.id: (context) => LoginView(),
          RegisterView.id: (context) => RegisterView(),
          ChatView.id: (context) => ChatView(),
        },
        initialRoute: LoginView.id,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
