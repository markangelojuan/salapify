import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SplitBillsScreen extends ConsumerStatefulWidget {
  const SplitBillsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SplitBillsScreenState();
}

class _SplitBillsScreenState extends ConsumerState<SplitBillsScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Split Bills Screen"),),);
  }
}