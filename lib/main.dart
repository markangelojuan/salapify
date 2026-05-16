import 'package:salapify/firebase_options.dart';
import 'package:salapify/router/routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      routerConfig: ref.watch(goRouterProvider),
      title: 'BudgetBai',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: .fromSeed(
          seedColor: const Color.fromARGB(255, 29, 116, 72),
        ),
        appBarTheme: const AppBarTheme().copyWith(
          backgroundColor: const Color.fromARGB(255, 29, 116, 72),
          centerTitle: true,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData().copyWith(
          backgroundColor: const Color.fromARGB(255, 29, 116, 72),
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
        ),
      ),
    );
  }
}
