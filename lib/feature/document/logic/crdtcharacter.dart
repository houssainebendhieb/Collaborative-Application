import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class CRDTCharacter {
  final String id;  // Unique ID (position, user, timestamp)
  final String value;
  final String userId;
  final int timestamp; 

  CRDTCharacter({
    required this.id,
    required this.value,
    required this.userId,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'value': value,
      'userId': userId,
      'timestamp': timestamp,
    };
  }

  static CRDTCharacter fromMap(Map<String, dynamic> map) {
    return CRDTCharacter(
      id: map['id'],
      value: map['value'],
      userId: map['userId'],
      timestamp: map['timestamp'],
    );
  }
}

class CRDTTextEditor {
  final List<CRDTCharacter> text = [];
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String documentId;

  CRDTTextEditor({required this.documentId});

  Future<void> addCharacter(String value, String userId) async {
    final newChar = CRDTCharacter(
      id: Uuid().v4(), 
      value: value,
      userId: userId,
      timestamp: DateTime.now().millisecondsSinceEpoch,
    );

    text.add(newChar);
    text.sort((a, b) => a.timestamp.compareTo(b.timestamp)); // Keep correct order

    await firestore.collection('docs').doc("Mrf9JsBk7hVxDI1TxcGq").collection('content').doc(newChar.id).set(newChar.toMap());
  }

  Future<void> removeCharacter(String charId) async {
    text.removeWhere((char) => char.id == charId);
    await firestore.collection('docs').doc("Mrf9JsBk7hVxDI1TxcGq").collection('content').doc(charId).delete();
  }

  Stream<List<CRDTCharacter>> syncText() {
    return firestore.collection('docs').doc("Mrf9JsBk7hVxDI1TxcGq").collection('content')
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => CRDTCharacter.fromMap(doc.data())).toList();
    });
  }
}
