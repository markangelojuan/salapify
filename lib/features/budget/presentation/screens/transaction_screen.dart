import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TransactionScreen extends ConsumerStatefulWidget {
  const TransactionScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends ConsumerState<TransactionScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Text("Transaction Screen"),),);
  }
}