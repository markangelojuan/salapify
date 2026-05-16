import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:salapify/features/authentication/presentation/controllers/auth_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text('Home')), body: ElevatedButton(onPressed: () {
      ref.read(authControllerProvider.notifier).signOut();
    }, child: Text('Sign out')),);
  }
}
