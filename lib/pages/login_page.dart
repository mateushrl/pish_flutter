import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pish_flutter/pages/home_page.dart';

import '../Util/app_theme .dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController =
      TextEditingController(text: "mateushrl918@gmail.com");
  TextEditingController senhaController =
      TextEditingController(text: '123456789');
  final _formKey = GlobalKey<FormState>();
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('fundoLogin.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Center(
          child: Container(
            width: 450,
            height: 500,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: const Color.fromARGB(255, 255, 255, 255),
            ),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.fromLTRB(20, 20, 20, 60),
                      child: const Text(
                        "Login",
                        style: AppTheme.titleTextStyle,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(
                          Icons.email,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.primaryColor, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Informe um e-mail válido.";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: TextFormField(
                      obscureText: _obscureText,
                      controller: senhaController,
                      decoration: InputDecoration(
                        labelText: 'Senha',
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        prefixIcon: const Icon(
                          Icons.password,
                        ),
                        suffixIcon: InkWell(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                        ),
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                              color: AppTheme.primaryColor, width: 2.0),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Informe uma senha válida.";
                        } else {
                          return null;
                        }
                      },
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(20),
                    width: double.infinity,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processando...')),
                          );
                          bool autorizado = await login();
                          nextPage(autorizado);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(AppTheme.primaryColor),
                      ),
                      child: const Text("Entrar",
                          style: TextStyle(
                              color: Color.fromARGB(255, 255, 255, 255))),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    ));
  }

  Future<bool> login() async {
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: senhaController.text);
      if (credential.user?.uid != null) {
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      return false;
    }
  }

  void nextPage(bool autorizado) {
    if (autorizado) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content:
                Text('Acesso não autorizado, verifique suas credenciais.')),
      );
    }
  }
}
