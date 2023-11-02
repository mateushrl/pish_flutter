import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
    
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late DatabaseReference ref;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    ref = FirebaseDatabase.instance.ref();
    final snapshot = await ref.child('umidade_solo').get();
    if (snapshot.exists) {
      print(snapshot.value);
    } else {
      print('NAO FOI');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: Container(),
    );
  }
}