// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:convert';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:emailjs/emailjs.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:semviolencia1/Episodio.dart';
import 'package:semviolencia1/Login.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

import 'Programa.dart';

void main() {
  runApp(const MyApp());
}

Color cor = Color.fromARGB(255, 56, 6, 68);
Color cor2 = Color.fromARGB(255, 136, 67, 214);

class MyApp extends StatelessWidget {
  //ATRIBUTOS

  const MyApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
          primarySwatch: Colors.purple,
          scaffoldBackgroundColor: Colors.grey[900],
          inputDecorationTheme: InputDecorationTheme(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                borderSide: BorderSide(width: 2, color: cor2)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(40)),
              borderSide: BorderSide(width: 2, color: cor),
            ),
          )),
      home: LoginPage(), //const MyHomePage(title: 'Sem Violência Podcast'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

TextEditingController cnome = new TextEditingController();

Future<List<ProgramaPage>> getProg() async {
  final response = await http.get(
      Uri.parse("http://localhost/semviolencia/getprog.php")
          .replace(queryParameters: {'nome': cnome.text}));
  List est = json.decode(response.body);
  return est.map((programas) => ProgramaPage.fromJson(programas)).toList();
}

Widget mostraLista(List<ProgramaPage> list1) {
  return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 650,
          childAspectRatio: 16 / 9,
          crossAxisSpacing: 30,
          mainAxisSpacing: 30),
      itemCount: list1.length,
      itemBuilder: (BuildContext ctx, index) {
        return Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
            decoration: BoxDecoration(
                color: Colors.grey[850],
                borderRadius: BorderRadius.circular(12)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            child: Image.network(list1[index].imagem),
                            width: 150),
                      ]),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: Text(
                            list1[index].nome,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                              fontFamily: "Poppins",
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(5),
                        ),
                        SizedBox(
                          width: 300,
                          child: Text(
                            softWrap: true,
                            list1[index].descricao,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w100,
                                fontFamily: "Poppins",
                                height: 1.7),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                        ),
                        Row(
                          children: [
                            ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Color.fromARGB(255, 136, 67, 214)),
                                    padding: MaterialStateProperty.all<EdgeInsets>(
                                        EdgeInsets.fromLTRB(30, 20, 30, 20)),
                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                            side: BorderSide(
                                                color: Color.fromARGB(
                                                    255, 136, 67, 214))))),
                                child: Text('Ver episódios'),
                                onPressed: () {
                                  Navigator.push(
                                      ctx,
                                      MaterialPageRoute(
                                          builder: (ctx) => ProgramaPage(
                                                nome: list1[index].nome,
                                                descricao:
                                                    list1[index].descricao,
                                                descComp: list1[index].descComp,
                                                imagem: list1[index].imagem,
                                              )));
                                }),
                          ],
                        )
                      ]),
                ]));
      });
}

Future sendEmailJS({
  required String cnome,
  required String cemail,
  required String ctelefone,
  required String cmsg,
}) async {
  try {
    await EmailJS.send(
      'service_dj0ptln',
      'template_qth3o1v',
      {
        'user_email': cemail,
        'user_message': cmsg,
        'user_phone': ctelefone,
        'user_name': cnome,
      },
      const Options(
        publicKey: 'IK5g6Mdwpj7ldWwE9',
        privateKey: 'oCv-c3LLaauso31Zsd2CK',
      ),
    );
    print('SUCCESS!');
  } catch (error) {
    if (error is EmailJSResponseStatus) {
      print('ERROR... ${error.status}: ${error.text}');
    }
    print(error.toString());
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final _contatoKey = GlobalKey<FormState>();
  SnackBar snackBarMsg = SnackBar(content: Text('Mensagem enviada!'));
  MaskTextInputFormatter maskTel =
      MaskTextInputFormatter(mask: '(##) #####-####');
      
  TextEditingController cnome = new TextEditingController();
  TextEditingController ctelefone = new TextEditingController();
  TextEditingController cemail = new TextEditingController();
  TextEditingController cmsg = new TextEditingController();


  void actionPopUpItemSelected(String value) {
    print(value);
    if (value == 'sair') {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
  }

  ButtonStyle meuBotao = ButtonStyle(
      backgroundColor:
          MaterialStateProperty.all<Color>(Color.fromARGB(255, 136, 67, 214)),
      padding: MaterialStateProperty.all<EdgeInsets>(
          EdgeInsets.fromLTRB(45, 20, 45, 20)),
      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
              side: BorderSide(color: Color.fromARGB(255, 136, 67, 214)))));

  List<Widget> footer = [];
  void initState() {
    footer.add(Container(color: Colors.white, width: 1000));
  }

  double tamanhoImagens = 75;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //HEADER
          Container(
              padding: EdgeInsets.fromLTRB(80, 20, 80, 20),
              color: Color.fromARGB(255, 56, 6, 68),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    child: Image(
                      image: AssetImage('/img/svlogoh.png'),
                      width: 150,
                    ),
                  ),
                  Container(
                    child: Row(
                      children: [
                        SizedBox(
                          child: Text(
                            'Home',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ),
                        Padding(padding: EdgeInsets.all(30)),
                        SizedBox(
                            child: PopupMenuButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(20.0),
                            ),
                          ),
                          icon: Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          color: Colors.purple,
                          itemBuilder: ((context) {
                            return [
                              PopupMenuItem(
                                child: Text(
                                  'Sair',
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: 'sair',
                              ),
                            ];
                          }),
                          onSelected: ((value) async {
                            actionPopUpItemSelected(value);
                          }),
                        )),
                      ],
                    ),
                  )
                ],
              )),

          //TITULO
          Container(
              child: Center(
            child: Container(
              padding: EdgeInsets.fromLTRB(0, 60, 0, 70),
              child: Column(
                children: [
                  Text(
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                      "Bem vindo(a) ao Sem Violência Podcast:"),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: "Poppins",
                          fontSize: 22,
                          fontWeight: FontWeight.w100),
                      "O lugar onde você pode se sentir acolhido e ouvido."),
                ],
              ),
            ),
          )),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('/img/programas.png'),
                  width: tamanhoImagens,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  'Programas',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
            child: FutureBuilder<List<ProgramaPage>>(
              future: getProg(),
              builder: (ctx, ss) {
                if (ss.hasError) {
                  print(ss.data);
                  print('moios');
                }
                if (ss.hasData) {
                  List<ProgramaPage> list1 = ss.data!;
                  return mostraLista(list1);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
          ),

          //SOBRE NÓS
          Padding(padding: EdgeInsets.all(10)),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('/img/sobre.png'),
                  width: tamanhoImagens,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  'Sobre Nós',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(10)),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: Text(
                    "O grupo organizador do projeto é constituído de três alunos do Ensino Médio Integrado ao Curso Técnico em Informática do Instituto Federal de Educação, Ciência e Tecnologia do Rio Grande do Sul - Campus Erechim, sendo eles Levi da Rosa Gomes, Luiz Eduardo Gallina Sfredo e João Vitor Martins. O grupo formado no primeiro trimestre de 2022 tem como orientador o professor Miguelangelo Corteze, professor da matéria curricular de Projeto Integrador e de História, além de integrar outros Núcleos do próprio instituto.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w100,
                        fontFamily: "Poppins",
                        height: 1.7),
                  ),
                  width: 350,
                ),
                Padding(padding: EdgeInsets.all(25)),
                SizedBox(
                  child: Image(
                    image: AssetImage('/img/nos.png'),
                    width: 450,
                  ),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),

          //CONTATE-NOS
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(
                  image: AssetImage('/img/contate.png'),
                  width: tamanhoImagens,
                ),
                Padding(padding: EdgeInsets.all(10)),
                Text(
                  'Contate-nos',
                  style: TextStyle(color: Colors.white, fontSize: 22),
                )
              ],
            ),
          ),
          Padding(padding: EdgeInsets.all(20)),
          Container(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              //FORM
              Container(
                  width: 600,
                  child: Form(
                      key: _contatoKey,
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              //NOME
                              SizedBox(
                                width: 290,
                                child: TextFormField(
                                  controller: cnome,
                                  style: TextStyle(color: Colors.white),
                                  cursorColor: cor,
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                      ),
                                      hintText: "",
                                      labelText: "Nome",
                                      labelStyle: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  validator: ((value) {
                                    if (value!.length < 3) {
                                      return 'Informe o nome completo';
                                    }
                                  }),
                                ),
                              ),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                              //TELEFONE
                              SizedBox(
                                width: 290,
                                child: TextFormField(
                                  controller: ctelefone,
                                  cursorColor: cor,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [maskTel],
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 1),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                      ),
                                      labelText: 'Telefone',
                                      labelStyle: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  validator: ((value) {
                                    if (value!.length < 3) {
                                      return 'Informe o telefone completo';
                                    }
                                  }),
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                          Row(
                            children: [
                              //EMAIL
                              SizedBox(
                                width: 600,
                                child: TextFormField(
                                  controller: cemail,
                                  cursorColor: cor,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.name,
                                  decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                          color: Colors.white,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                      ),
                                      labelText: 'E-mail',
                                      labelStyle: TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  validator: ((value) {
                                    if (value!.length < 3) {
                                      return 'Informe o e-mail completo';
                                    }
                                  }),
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                          Row(
                            children: [
                              //MENSAGEM
                              SizedBox(
                                width: 600,
                                child: TextField(
                                  controller: cmsg,
                                  cursorColor: cor,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.multiline,
                                  maxLines: 6,
                                  decoration: InputDecoration(
                                    labelText: 'Mensagem',
                                    labelStyle: TextStyle(
                                        color: Colors.white, fontSize: 14),
                                  ),
                                  /* validator: ((value) {
                                    if (value!.length < 3) {
                                      return 'Informe o nome completo';
                                    }
                                  }), */
                                ),
                              )
                            ],
                          ),
                          Padding(padding: EdgeInsets.fromLTRB(0, 10, 0, 10)),

                          //ENVIAR
                          ElevatedButton(
                            style: meuBotao,
                            onPressed: () {
                              if (_contatoKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBarMsg);
                                sendEmailJS(
                                    cnome: cnome.text,
                                    cemail: cemail.text,
                                    ctelefone: ctelefone.text,
                                    cmsg: cmsg.text);
                                print('form ok');
                              }
                            },
                            child: Text('Enviar'),
                          )
                        ],
                      ))),
              Padding(padding: EdgeInsets.all(25)),
              //REDES SOCIAIS
              Container(
                child: Column(
                  children: [
                    Image(
                      image: AssetImage('/img/redes.png'),
                      width: 250,
                    )
                  ],
                ),
              ),
            ]),
          ),
          Padding(padding: EdgeInsets.all(20)),

          //FOOTER
          Container(
              height: 80,
              padding: EdgeInsets.all(9),
              color: Color.fromARGB(255, 56, 6, 68),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        child: Image.network(
                            '//localhost/semviolencia/prog/svlogoh.png'),
                        width: 100),
                    SizedBox(
                        child: Image.network(
                            '//localhost/semviolencia/prog/logoif.png'),
                        width: 130),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text('Instagram',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                        Text('Twitter',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                        Text('Youtube',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('© 2022 Sem Violência Podcast)',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)),
                        Text('Nenhum direito reservado',
                            style: TextStyle(color: Colors.white, fontSize: 10))
                      ],
                    )
                  ])),
        ],
      ),
    ));
  }
}
