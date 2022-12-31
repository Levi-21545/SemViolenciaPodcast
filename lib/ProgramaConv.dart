// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:convert';
import 'dart:js';

import 'package:confirm_dialog/confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import 'package:semviolencia1/Episodio.dart';
//import 'editdata.dart';
import 'package:http/http.dart' as http;

import 'newdata.dart';

class ProgramaPageConv extends StatefulWidget {
  final String nome;
  final String descricao;
  final String descComp;
  final String imagem;
  const ProgramaPageConv(
      {Key? key,
      required this.nome,
      required this.descricao,
      required this.descComp,
      required this.imagem});

  factory ProgramaPageConv.fromJson(Map<String, dynamic> jsonData) {
    return ProgramaPageConv(
      nome: jsonData['nome'],
      descricao: jsonData['descricao'],
      descComp: jsonData['descComp'],
      imagem: "http://localhost/semviolencia/prog/" + jsonData['imagem'],
    );
  }

  @override
  _ProgramaState createState() => _ProgramaState();
}

class _ProgramaState extends State<ProgramaPageConv> {
  TextEditingController ctitulo = new TextEditingController();
  Uint8List imageData = new Uint8List(500);
  int contador = 0;
  String programa = '';

  void delete(Episodio ep) {
    var url = "http://localhost/semviolencia/deletedata.php";
    print(ep.programa);
    http.post(Uri.parse(url), body: {
      //'id': ep.id.toString(),
      'programa': ep.programa,
      'titulo': ep.titulo,
    });
  }

  void actionPopUpItemSelected(String value, Episodio ep) {
    String message;
    print('entrou');
    if (value == 'editar') {
      print('editando');
    } else if (value == 'excluir') {
      print('apagou');
      delete(ep);
      setState(() {
        getData();
      });
    }
  }

  Widget mostraLista(List<Episodio> list1) {
    List<AudioPlayer> players = [];
    for (int i = 0; i < list1.length; i++) {
      final player = AudioPlayer();
      players.add(player);
    }

    final player = AudioPlayer();

    return GridView.builder(
        shrinkWrap: true,
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 350,
            mainAxisExtent: 300,
            childAspectRatio: 16 / 14,
            crossAxisSpacing: 30,
            mainAxisSpacing: 30),
        itemCount: list1.length,
        itemBuilder: (ctx, i) {
          return Container(
              //height: 1000,
              margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
              padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
              decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Image.network(
                                  list1[i].thumb,
                                  width: 270,
                                  height: 180,
                                )),
                          ]),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        //crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    list1[i].titulo,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                                Padding(
                                    padding: EdgeInsets.fromLTRB(0, 5, 0, 5)),
                                SizedBox(
                                  width: 220,
                                  child: Text(
                                    softWrap: true,
                                    list1[i].dia + " • " + list1[i].duracao,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      fontStyle: FontStyle.italic,
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w100,
                                      fontFamily: "Poppins",
                                    ),
                                  ),
                                ),
                              ]),
                          Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                    child: ControlButtons(
                                        players[i], list1[i].arq))
                              ]),
                          //Padding(padding: EdgeInsets.fromLTRB(10, 0, 10, 0)),
                        ],
                      ),
                    ]),
              ));
        });
  }

  Future<List<Episodio>> getData() async {
    final response = await http.get(
        Uri.parse("http://localhost/semviolencia/getdata.php")
            .replace(queryParameters: {'programa': programa}));
    List est = json.decode(response.body);
    return est
        .map((episodiosnepgs) => Episodio.fromJson(episodiosnepgs))
        .toList();
  }

  final ScrollController _firstController = ScrollController();

  initState() {
    if (widget.nome == 'NEABI Talks') {
      programa = 'episodiosneabi';
    }
    if (widget.nome == 'NEPGS Talks') {
      programa = 'episodiosnepgs';
    }
    if (widget.nome == 'Sem Violência Podcast') {
      programa = 'episodiossv';
    }
    if (widget.nome == 'Web Rádio Hélio Pomorski') {
      programa = 'episodioswebradio';
    }
    print("nome do programa: " + programa);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nome),
        backgroundColor: Color.fromARGB(255, 56, 6, 68),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            //CONTAINER TITULO
            Container(
              margin: EdgeInsets.all(40),
              padding: EdgeInsets.fromLTRB(0, 40, 0, 40),
              decoration: BoxDecoration(
                  color: Colors.grey[850],
                  borderRadius: BorderRadius.circular(12)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                            width: 120, child: Image.network(widget.imagem))
                      ]),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        child: Text(
                          widget.nome,
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
                        padding: EdgeInsets.all(10),
                      ),
                      SizedBox(
                        width: 1000,
                        child: Text(
                          softWrap: true,
                          widget.descComp,
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
                    ],
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),

            //DIVISAO
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image(
                    image: AssetImage('/img/pogramas.png'),
                    width: 75,
                  ),
                  Padding(padding: EdgeInsets.all(10)),
                  Text(
                    'Episódios',
                    style: TextStyle(color: Colors.white, fontSize: 22),
                  )
                ],
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 0)),

            Container(
              padding: EdgeInsets.fromLTRB(40, 0, 40, 0),
              child: FutureBuilder<List<Episodio>>(
                initialData: [],
                future: getData(),
                builder: (ctx, ss) {
                  if (ss.hasError) {
                    print(ss.error);
                    print(ss.data);
                    print('moios');
                  }
                  if (ss.hasData) {
                    print('hasdata');
                    List<Episodio> list1 = ss.data!;
                    return mostraLista(list1);
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
            ),
            Padding(padding: EdgeInsets.fromLTRB(0, 20, 0, 20)),

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
                              style:
                                  TextStyle(color: Colors.white, fontSize: 10))
                        ],
                      )
                    ])),
          ],
        ),
      ),
    );
  }
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;
  final String arq;

  const ControlButtons(this.player, this.arq, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //PROBLEMA AQUI
    player.setUrl(arq);
    player.load;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(8.0),
                width: 30.0,
                height: 30.0,
                child: const CircularProgressIndicator(),
              );
            } else if (playing != true) {
              return FloatingActionButton(
                mini: true,
                onPressed: player.play,
                child: const Icon(Icons.play_arrow),
              );
            } else if (processingState != ProcessingState.completed ||
                player.duration == Duration.zero) {
              return FloatingActionButton(
                mini: true,
                onPressed: player.pause,
                child: const Icon(Icons.pause),
              );
            } else {
              return FloatingActionButton(
                mini: true,
                onPressed: () => player.seek(Duration.zero),
                child: const Icon(Icons.replay),
              );
            }
          },
        ),
      ],
    );
  }
}
