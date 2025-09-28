import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:myapp/helper/show_snack_bar.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());
  Future<void> SignInUser({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      emit(LoginSucess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure(errMessage: 'User Not Found'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure(errMessage: 'Wrong Password'));
      }
    } catch (e) {
      emit(LoginFailure(errMessage: 'Something went wrong, Please try again'));
    }
  }
}
