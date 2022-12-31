// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:semviolencia1/Player.dart';
import 'package:semviolencia1/main.dart';

import 'mainConv.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool isPasswordVisible = false;

  SnackBar snackBarCerto = SnackBar(content: Text('Login Realizado'));
  SnackBar snackBarErro = SnackBar(content: Text('Login Inválido'));

  ButtonStyle meuBotao = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(255, 136, 67, 214)),
      padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.fromLTRB(45, 20, 45, 20)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Color.fromARGB(255, 136, 67, 214)))));
  ButtonStyle botaoConv = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(0, 136, 67, 214)),
      padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.fromLTRB(45, 20, 45, 20)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Color.fromARGB(255, 136, 67, 214)))));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: SizedBox(
                width: 600,
                height: 600,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Image(
                          image: AssetImage('/img/svlogoh.png'),
                          width: 250,
                        ),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),
                      TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          label: Text(
                            'E-mail',
                            style: TextStyle(color: Colors.white),
                          ),
                          hintText: 'nome@email.com',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: _emailController,
                        validator: (email) {
                          if (email == null || email.isEmpty) {
                            return 'Digite seu e-mail';
                          }
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                      TextFormField(
                        obscureText: true,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          label: Text(
                            'Senha',
                            style: TextStyle(color: Colors.white),
                          ),
                          hintText: 'Digite sua senha',
                          hintStyle: TextStyle(color: Colors.grey),
                        ),
                        controller: _senhaController,
                        validator: (senha) {
                          if (senha == null || senha.isEmpty) {
                            return 'Digite sua senha';
                          } else if (senha.length <= 7) {
                            return 'Digite uma senha mais forte';
                          }
                          return null;
                        },
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: meuBotao,
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  checalogin(
                                      'http://localhost/semviolencia/veruser.php',
                                      _emailController.text,
                                      _senhaController.text);
                                }
                              },
                              child: Text('Entrar')),
                          Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                          ElevatedButton(
                              style: botaoConv,
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        MyHomePageConv(title: 'Home'),
                                    //PlayerPage(),
                                  ),
                                );
                              },
                              child: Text('Entrar como convidado')),
                        ],
                      )
                    ],
                  ),
                ),
              ))),
    );
  }

  Future<String> verUser(url, email, senha) async {
    final response = await http.get(Uri.parse(url)
        .replace(queryParameters: {'email': email, 'senha': senha}));
    print(response.body);
    return Future.value(response.body);
  }

  Future<void> checalogin(url, email, senha) async {
    String teste;
    teste = await verUser(url, email, senha);
    if (teste == '1') {
      ScaffoldMessenger.of(context).showSnackBar(snackBarCerto);
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => MyHomePage(
                    title: 'Home',
                  )));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(snackBarErro);
    }
  }
}
