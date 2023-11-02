import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:pish_flutter/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController senhaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(''),
      ),
      body: Center(
        child: Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            height: MediaQuery.of(context).size.width / 3.5,
            width: MediaQuery.of(context).size.width / 1.5,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Row(
              children: [
                Flexible(
                  child: Container(
                    padding: EdgeInsets.all(100),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Login",
                          style: TextStyle(color: Colors.black, fontSize: 50),
                        ),
                        //Image.asset('assets/logo.png'),
                        const SizedBox(
                          height: 30,
                        ),
                        Form(
                          child: Column(
                            children: [
                              TextField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  labelText: 'E-mail',
                                ),
                              ),
                              TextField(
                                keyboardType: TextInputType.text,
                                controller: senhaController,
                                obscureText: true,
                                decoration: const InputDecoration(
                                  labelText: 'Senha',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),

                        InkWell(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const HomePage(),
                              ),
                            );
                          },
                          child: Container(
                            width: double.infinity,
                            alignment: Alignment.center,
                            height: 30,
                            decoration: BoxDecoration(
                                color: Colors.yellow,
                                borderRadius: BorderRadius.circular(2)),
                            child: Text("Entrar"),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
