import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  RegisterCubit() : super(RegisterInitial());

  Future<void> RegisterUser({
    required String email,
    required String password,
  }) async {
    emit(RegisterLoading());
    try {
      UserCredential user = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      emit(RegisterSucess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        emit(RegisterFailure(errMessage: 'This email is already in use'));
      } else if (e.code == 'weak-password') {
        emit(RegisterFailure(errMessage: 'Password is too weak'));
      } else if (e.code == 'invalid-email') {
        emit(RegisterFailure(errMessage: 'Invalid email format'));
      } else {
        emit(
          RegisterFailure(errMessage: 'Registration failed, please try again'),
        );
      }
    } catch (e) {
      emit(
        RegisterFailure(errMessage: 'Something went wrong, Please try again'),
      );
    }
  }
}
