import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DocumentPage extends StatefulWidget {
  @override
  _CRDTTextEditorState createState() => _CRDTTextEditorState();
}

class _CRDTTextEditorState extends State<DocumentPage> {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final String docId = "houssaine";
  TextEditingController _controller = TextEditingController();
  List<CRDTItem> items = [];

  @override
  void initState() {
    super.initState();
    _listenForUpdates();
  }

  // 🔥 Listen for real-time updates
  void _listenForUpdates() {
    _db
        .collection("docs")
        .doc(docId)
        .collection("items")
        .orderBy("timestamp", descending: false)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        items =
            snapshot.docs.map((doc) => CRDTItem.fromJson(doc.data())).toList();
        if (_controller.text != _getText()) {
          _controller.text = _getText();
        }
      });
    });
  }
  // 📝 Convert items to string
  String _getText() {
    return items
        .where((item) => !item.isDeleted)
        .map((e) => e.content)
        .join("");
  }
  // ✍️ Insert character
  void _insertCharacter(String content) {
    String id = "${DateTime.now().millisecondsSinceEpoch}@user";
    CRDTItem newItem = CRDTItem(
        id: id,
        content: content,
        timestamp: DateTime.now().millisecondsSinceEpoch);

    _db
        .collection("docs")
        .doc(docId)
        .collection("items")
        .doc(id)
        .set(newItem.toJson());
  }
  // ❌ Delete character
  void _deleteCharacter() {
    print("delete");
    if (items.isNotEmpty) {
      String lastItemId = items.last.id;
      _db
          .collection("docs")
          .doc(docId)
          .collection("items")
          .doc(lastItemId)
          .update({"isDeleted": true});
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(title: const Text("CRDT Text Editor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              maxLines: 20,
              decoration: InputDecoration(),
              controller: _controller,
              onChanged: (text) {
                if (text.length > _getText().length) {
                  _insertCharacter(text[text.length - 1]);
                } else {
                  _deleteCharacter();
                }
              },
            ),
            SizedBox(height: 20),
            Text("Live Document:"),
            StreamBuilder(
              stream: _db
                  .collection("docs")
                  .doc(docId)
                  .collection("items")
                  .where("isDeleted", isEqualTo: false)
                  .orderBy("timestamp", descending: false)
                  .snapshots(),
              builder: (context, snapshot) {
                print(snapshot);
                if (!snapshot.hasData) return const CircularProgressIndicator();
                List<CRDTItem> liveItems = snapshot.data!.docs
                    .map((doc) => CRDTItem.fromJson(doc.data()))
                    .toList();
                return Text(liveItems.map((e) => e.content).join(""),
                    style: TextStyle(fontSize: 18));
              },
            ),
          ],
        ),
      ),
    );
  }
}

// 🏗 CRDT Item Model
class CRDTItem {
  final String id;
  final String content;
  final int timestamp;
  bool isDeleted;

  CRDTItem(
      {required this.id,
      required this.content,
      required this.timestamp,
      this.isDeleted = false});

  Map<String, dynamic> toJson() => {
        'id': id,
        'content': content,
        'timestamp': timestamp,
        'isDeleted': isDeleted,
      };

  static CRDTItem fromJson(Map<String, dynamic> json) {
    return CRDTItem(
      id: json['id'],
      content: json['content'],
      timestamp: json['timestamp'],
      isDeleted: json['isDeleted'] ?? false,
    );
  }
}
