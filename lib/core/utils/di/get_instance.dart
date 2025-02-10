import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';
import 'package:google_docs_clone/feature/homepage/data/logic/homepage_repo.dart';
import 'package:google_docs_clone/feature/homepage/data/logic/homepage_repo_imp.dart';
import 'package:google_docs_clone/feature/invitation/logic/repo/invitation_repo.dart';
import 'package:google_docs_clone/feature/invitation/logic/repo/invitation_repo_imp.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> setup() async {
  final shared = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => shared);
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<HomepageRepo>(() => HomepageRepoImp());
  getIt.registerLazySingleton<InvitationRepo>(() => InvitationRepoImp());
}
