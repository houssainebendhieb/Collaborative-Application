import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_docs_clone/core/next/doc.dart';
import 'package:google_docs_clone/core/next/page.dart';
import 'package:uuid/uuid.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final nameController = TextEditingController();
  List<Map<String, dynamic>> documents = [];
  Future<void> getAllDocument() async {
    final _firebase = FirebaseFirestore.instance;
    QuerySnapshot res = await _firebase.collection("documents").get();
    for (var item in res.docs) {
      documents.add(item.data() as Map<String, dynamic>);
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getAllDocument();
    print("initState");
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        floatingActionButton: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const Homepage()));
            },
            child: const Icon(Icons.replay_outlined)),
        appBar: AppBar(
          actions: const [Text("Welcome Mr to our application")],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Column(
            children: [
              const Text("List of our document "),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.all(10),
                child: ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () async {
                          final docPageData = await FirebaseFirestore.instance
                              .collection('documents')
                              .where("id", isEqualTo: documents[index]['id'])
                              .get();
                          var id = docPageData.docs.first.id;
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      DocPage(documentId: id)));
                        },
                        child: ListTile(
                          title: Text(documents[index]['title']),
                        ),
                      );
                    }),
              )),
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Document Name",
                  enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.black),
                      borderRadius: BorderRadius.circular(25)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(25)),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () async {
                    final _firebase = FirebaseFirestore.instance;
                    final id = Uuid().v1();
                    DocumentReference doc =
                        await _firebase.collection("documents").add({
                      "id": id,
                      "title": nameController.text,
                      "content": [
                        {"insert": ""}
                      ]
                    });
                    nameController.clear();
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DocPage(documentId: id)));
                  },
                  child: const Icon(Icons.add))
            ],
          ),
        ),
      ),
    );
  }
}
