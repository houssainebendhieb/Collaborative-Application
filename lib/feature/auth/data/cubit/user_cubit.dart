import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/feature/homepage/views/homepage.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return const HomePageScreen();
      }));
    } on FirebaseAuthException catch (e) {
      emit(UserLoginFailure(errorMessage: 'Invalide password or email'));
    } catch (e) {
      print(e);
    }
  }

  Future<void> SignUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(UserSignUpFailure(
            errorMessage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {
        emit(UserSignUpFailure(
            errorMessage: 'The account already exists for that email.'));
      } else {
        emit(UserSignUpFailure(errorMessage: e.code));
      }
    } catch (e) {
      emit(UserSignUpFailure(errorMessage: e.toString()));
    }
  }

  Future<void> SignOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
