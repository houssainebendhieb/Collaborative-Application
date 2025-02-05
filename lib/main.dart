import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_docs_clone/feature/document/logic/cubit/document_page_cubit.dart';
import 'package:google_docs_clone/feature/document/views/document_page.dart';
import 'package:google_docs_clone/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: BlocProvider(
      create: (context) => DocumentPageCubit(),
      child: const DocumentPageScreen(),
    ),
  ));
}
