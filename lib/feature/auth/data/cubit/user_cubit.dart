import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/core/utils/di/get_instance.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());
  final _firebase = getIt.get<FirebaseFirestore>();
  Future<void> login(
      {required String email,
      required String password,
      required BuildContext context}) async {
    try {
      var res = await _firebase
          .collection("user")
          .where("email", isEqualTo: email)
          .get();
      Map<String, dynamic> data =
          res.docChanges.first.doc.data() as Map<String, dynamic>;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("id", data['id']);
      prefs.setString("email", data['email']);
      prefs.setString("password", data['password']);
      print("here");
      print(res);
      print("id de user : ${data['id']}");
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      emit(UserLoginFailure(errorMessage: 'Invalide password or email'));
    } catch (e) {
      print(e);
    }
  }

  Future<bool> SignUp({required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      DocumentReference doc = await _firebase
          .collection("user")
          .add({"email": email, "password": password});
      await _firebase.collection("user").doc(doc.id).update({"id": doc.id});
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      return true;
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
      return false;
    } catch (e) {
      emit(UserSignUpFailure(errorMessage: e.toString()));
      return false;
    }
  }
  Future<void> SignOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove("id");
    await prefs.remove("email");
    await FirebaseAuth.instance.signOut();
  }

}
