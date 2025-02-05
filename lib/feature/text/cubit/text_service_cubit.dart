import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'text_service_state.dart';

class TextServiceCubit extends Cubit<TextServiceState> {
  TextServiceCubit() : super(TextServiceInitial());
  Timer? timer;
  final _firestore = FirebaseFirestore.instance;

  void getController({required String idDevice}) async {
    TextEditingController textController = TextEditingController();
    bool isTyping = false;
    String idTyping = "";
    int index = 0;
    bool vide = false;
    emit(TextServiceLoading());
    FirebaseFirestore.instance
        .collection("text")
        .doc("fGS4PAIRgIxNHx8qfVtv")
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final text = snapshot.data() as Map<String, dynamic>;
        textController.text = text['text'];
        isTyping = text['isTyping'] as bool;
        idTyping = text["idTyping"] as String;
        index = text['userTyping'][idDevice] ?? 0;
        vide = text['vide'];
      }
      emit(TextServiceSucces(
          index: index,
          timeOut: vide,
          textController: textController,
          whoTyping: isTyping,
          idTyping: idTyping));
    });
  }

  Future<void> changeTyping(String userId, bool change) async {
    final res = await FirebaseFirestore.instance
        .collection("text")
        .doc("fGS4PAIRgIxNHx8qfVtv")
        .get();
    print(userId);
    if (res.data()!['isTyping'] == false && change == true) {
      print("here");
      print(userId);
      await FirebaseFirestore.instance
          .collection("text")
          .doc("fGS4PAIRgIxNHx8qfVtv")
          .update({"isTyping": change, "idTyping": userId});
      // setTimerTyping();
      return;
    }

    if (change == false &&
        (res.data()!["isTyping"] == true &&
            userId == res.data()!['idTyping'])) {
      print("here 2");
      await FirebaseFirestore.instance
          .collection("text")
          .doc("fGS4PAIRgIxNHx8qfVtv")
          .update({"isTyping": change, "idTyping": userId});
      return;
    } else
      return;
  }

  /// Updates the text but prevents typing on the same index
  Future<void> updateText(
      String newText, int cursorIndex, String userId) async {
    var docRef = _firestore.collection('text').doc('fGS4PAIRgIxNHx8qfVtv');

    await _firestore.runTransaction((transaction) async {
      var snapshot = await transaction.get(docRef);
      if (!snapshot.exists) return;

      var data = snapshot.data() as Map<String, dynamic>;
      String currentText = data['text'] ?? "";
      Map<String, int> typingUsers =
          Map<String, int>.from(data['userTyping'] ?? {});

      // Prevent typing at the same index
      bool conflict = typingUsers.values.any(
          (index) => index == cursorIndex && index != typingUsers["userId"]);

      if (!conflict) {
        transaction.update(docRef, {
          'text': newText,
          'userTyping.$userId': cursorIndex,
          "idTyping": userId
        });
      }
    });
  }

  Future<void> setTimerTyping() async {
    timer?.cancel();
    timer = Timer(const Duration(seconds: 3), () async {
      await FirebaseFirestore.instance
          .collection("text")
          .doc("fGS4PAIRgIxNHx8qfVtv")
          .update({"vide": true, "isTyping": false, "idTyping": "houssaine"});
      print("device is close ");
    });
  }

  Future<void> changeVide() async {
    await FirebaseFirestore.instance
        .collection("text")
        .doc("fGS4PAIRgIxNHx8qfVtv")
        .update({"vide": false, "isTyping": false, "idTyping": "houssaine"});
  }

  Future<void> updateUserName(String newName, int index) async {
    timer?.cancel();
    FirebaseFirestore.instance
        .collection('text')
        .doc("fGS4PAIRgIxNHx8qfVtv")
        .update({'text': newName, 'index': index}).then((_) {
      //setTimerTyping();
    });
  }
}
