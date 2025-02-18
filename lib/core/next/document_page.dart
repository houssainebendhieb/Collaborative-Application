// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart';
// import 'package:uuid/uuid.dart';

// class DocumentPage extends StatefulWidget {
//   final String id;
//   const DocumentPage({super.key, required this.id});
//   @override
//   State<DocumentPage> createState() => _DocumentPageState();
// }

// class _DocumentPageState extends State<DocumentPage> {
//   Map<String, dynamic> document = {};
//   late DocumentSnapshot doc;
//   Future<void> getDocument() async {
//     final _firebase = FirebaseFirestore.instance;
//     QuerySnapshot response = await _firebase
//         .collection("documents")
//         .where("id", isEqualTo: widget.id)
//         .limit(1)
//         .get();
//     setState(() {
//       document = response.docs.first.data() as Map<String, dynamic>;
//       doc = response.docChanges.first.doc;
//       _controller.document = Document.fromJson(document['content']);
//     });
//     print(response.docChanges.first.doc.id);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       getDocument();
//       _controller.addListener(() {
//         _updateDocument();
//       });
//     });
//   }

//   void _updateDocument() {
//     final _firebase = FirebaseFirestore.instance;
//     _firebase
//         .collection("documents")
//         .doc(doc.id)
//         .update({"content": _controller.document.toDelta().toJson()});
//     print("here 2 ");
//   }

//   late QuillController _controller;

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
//               child: Row(
//                 children: [
//                   PopupMenuButton(
//                       child: const Text(
//                         "File ",
//                         style: TextStyle(fontSize: 20, color: Colors.black),
//                       ),
//                       itemBuilder: (context) => [
//                             PopupMenuItem(
//                               child: const Text('Delete Document'),
//                               onTap: () async {
//                                 // some logic

//                                 final _firebase = FirebaseFirestore.instance;
//                                 final uuid = Uuid();
//                                 await _firebase
//                                     .collection("documents")
//                                     .doc(doc.id)
//                                     .delete();
//                                 Navigator.pop(context);
//                               },
//                             ),
//                             PopupMenuItem(
//                               child: const Text('Save Document'),
//                               onTap: () async {
//                                 // some logic

//                                 final _firebase = FirebaseFirestore.instance;
//                                 await _firebase
//                                     .collection("documents")
//                                     .doc(doc.id)
//                                     .update({
//                                   "content":
//                                       _controller.document.toDelta().toJson()
//                                 });
//                               },
//                             ),
//                           ]),
//                   const SizedBox(
//                     width: 10,
//                   ),
//                   const Text("Edit ",
//                       style: TextStyle(fontSize: 20, color: Colors.black)),
//                   const SizedBox(
//                     width: 70,
//                   ),
//                   Expanded(
//                     child: Text(
//                       document['title'],
//                       style: const TextStyle(color: Colors.blue, fontSize: 25),
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                   )
//                 ],
//               ),
//             ),
//             QuillSimpleToolbar(
//               configurations:
//                   QuillSimpleToolbarConfigurations(controller: _controller),
//             ),
//             Expanded(
//               child: StreamBuilder<DocumentSnapshot>(
//                 stream: FirebaseFirestore.instance
//                     .collection('documents')
//                     .doc(doc.id)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (!snapshot.hasData || doc.data() == null)
//                     return const CircularProgressIndicator();

//                   Map<String, dynamic> data =
//                       snapshot.data!.data() as Map<String, dynamic>;

//                   if (data['content'] != null) {
//                     final newDocument = Document.fromJson(data['content']);
//                     if (_controller.document.toPlainText() !=
//                         newDocument.toPlainText()) {
//                       _controller.document =
//                           newDocument; // Update the document if changed
//                     }
//                   }

//                   return Card(
//                     elevation: 7,
//                     child: QuillEditor.basic(
//                       configurations: QuillEditorConfigurations(
//                         controller: _controller,
//                         customStyles: const DefaultStyles(
//                             h1: DefaultTextBlockStyle(
//                                 TextStyle(
//                                     fontSize: 50,
//                                     color: Colors.green,
//                                     height: 1.15),
//                                 VerticalSpacing(1, 0),
//                                 VerticalSpacing(0, 0),
//                                 BoxDecoration()),
//                             h2: DefaultTextBlockStyle(
//                                 TextStyle(
//                                     fontSize: 36,
//                                     color: Colors.black,
//                                     height: 1.15),
//                                 VerticalSpacing(1, 0),
//                                 VerticalSpacing(0, 0),
//                                 BoxDecoration())),
//                       ),
//                     ),
//                   ); // You can return an empty container here
//                 },
//               ),
//             )

//             /*   Expanded(
//               child: Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 25),
//                 child: Card(
//                   elevation: 7,
//                   child: QuillEditor.basic(
//                     configurations: QuillEditorConfigurations(
//                       controller: _controller,
//                       customStyles: const DefaultStyles(
//                           h1: DefaultTextBlockStyle(
//                               TextStyle(
//                                   fontSize: 50,
//                                   color: Colors.green,
//                                   height: 1.15),
//                               VerticalSpacing(1, 0),
//                               VerticalSpacing(0, 0),
//                               BoxDecoration()),
//                           h2: DefaultTextBlockStyle(
//                               TextStyle(
//                                   fontSize: 36,
//                                   color: Colors.black,
//                                   height: 1.15),
//                               VerticalSpacing(1, 0),
//                               VerticalSpacing(0, 0),
//                               BoxDecoration())),
//                     ),
//                   ),
//                 ),
//               ),
//             )*/
//             ,
//             ElevatedButton(
//                 onPressed: () {
//                   print(_controller.document.toDelta());
//                 },
//                 child: const Text("Click here"))
//           ],
//         ),
//       ),
//     );
//   }
// }
