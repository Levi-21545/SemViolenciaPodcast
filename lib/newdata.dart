// ignore_for_file: prefer_const_constructors

import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'main.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';

class NewData extends StatefulWidget {
  Uint8List imageData;
  Uint8List imageDataCheck;
  NewData(this.imageData, this.imageDataCheck);
  @override
  _NewDataState createState() => _NewDataState(imageData, imageDataCheck);
}

class _NewDataState extends State<NewData> {
  String programa = 'episodiosneabi';
  Uint8List imageData;
  Uint8List imageDataCheck;
  FilePickerResult? pickedFileArq;
  FilePickerResult? pickedFileThumb;
  var temp = new Uint8List(500);
  TextEditingController ctitulo = new TextEditingController();
  TextEditingController cdata = new TextEditingController();
  TextEditingController cduracao = new TextEditingController();
  //arq
  //thumb

  void loadAsset() async {
    Uint8List data =
        (await rootBundle.load('img/select.png')).buffer.asUint8List();
    setState(() => imageData = data);
    Uint8List data2 =
        (await rootBundle.load('img/check.png')).buffer.asUint8List();
    setState(() => imageDataCheck = data2);
  }

  @override
  void initState() {
    loadAsset();
  }

  final _formKey = GlobalKey<FormState>();

  _NewDataState(this.imageData, this.imageDataCheck);

  Future<String> addData() async {
    var url = "http://localhost/semviolencia/adddata.php";
    var request = http.MultipartRequest('POST', Uri.parse(url));
    request.fields['programa'] = programa;
    request.fields['titulo'] = ctitulo.text;
    request.fields['dia'] = cdata.text;
    request.fields['duracao'] = cduracao.text;
    request.fields['arq'] = pickedFileArq!.files[0].name;
    request.fields['thumb'] = pickedFileThumb!.files[0].name;
    request.files.add(
        http.MultipartFile.fromBytes('arqD', pickedFileArq!.files[0].bytes!));
    request.files.add(http.MultipartFile.fromBytes(
        'thumbD', pickedFileThumb!.files[0].bytes!));
    var res = await request.send();
    return Future.value(res.reasonPhrase);
  }

  void chooseImageArq() async {
    pickedFileArq = await FilePicker.platform
        .pickFiles(allowMultiple: false, withData: true);
    if (pickedFileArq != null) {
      try {
        setState(() {
          final logoBase64 = pickedFileArq!.files[0].bytes;
        });
      } catch (err) {
        print(err);
      }
    } else {
      print('No Image Selected');
    }
  }

  void chooseImageThumb() async {
    pickedFileThumb = await FilePicker.platform
        .pickFiles(allowMultiple: false, withData: true);
    if (pickedFileThumb != null) {
      try {
        setState(() {
          final logoBase64 = pickedFileThumb!.files[0].bytes;
        });
      } catch (err) {
        print(err);
      }
    } else {
      print('No Image Selected');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Enviar Episódio"),
        backgroundColor: Color.fromARGB(255, 56, 6, 68),
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              //TITULO
              SizedBox(
                  width: 200,
                  child: DropdownButton(
                    value: programa,
                    icon: Icon(Icons.arrow_downward),
                    iconSize: 24,
                    alignment: Alignment.center,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(40)),
                    dropdownColor: Colors.purple,
                    underline: Container(
                      height: 2,
                      color: Colors.purple,
                    ),
                    onChanged: (newValue) {
                      setState(() {
                        programa = newValue.toString();
                      });
                    },
                    items: const [
                      DropdownMenuItem(
                        value: 'episodiosneabi',
                        child: Text('NEABI Talks'),
                      ),
                      DropdownMenuItem(
                        value: 'episodiosnepgs',
                        child: Text('NEPGS Talks'),
                      ),
                      DropdownMenuItem(
                        value: 'episodiossv',
                        child: Text('Sem Violência Podcast'),
                      ),
                      DropdownMenuItem(
                        value: 'episodioswebradio',
                        child: Text('Web Rádio Hélio Pomorski'),
                      ),
                    ],
                    /* decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        hintText: "",
                        labelText: "Titulo",
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 14)), */
                  )),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              SizedBox(
                  width: 400,
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    keyboardType: TextInputType.text,
                    controller: ctitulo,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white, width: 1),
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                        hintText: "",
                        labelText: "Titulo",
                        labelStyle:
                            TextStyle(color: Colors.white, fontSize: 14)),
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Informe o título";
                      }
                    }),
                  )),

              Padding(
                padding: EdgeInsets.all(5),
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  keyboardType: TextInputType.text,
                  controller: cdata,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 0.1),
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    labelStyle: TextStyle(color: Colors.white, fontSize: 14),
                    hintText: "",
                    labelText: "Data",
                  ),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Informe a data";
                    }
                  }),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(5),
              ),
              SizedBox(
                width: 400,
                child: TextFormField(
                  style: TextStyle(color: Colors.white),
                  controller: cduracao,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red, width: 0.1),
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                      ),
                      hintText: "",
                      labelText: "Duração",
                      labelStyle: TextStyle(color: Colors.white, fontSize: 14)),
                  validator: ((value) {
                    if (value!.isEmpty) {
                      return "Informe a duração";
                    }
                  }),
                ),
              ),

              Padding(
                padding: EdgeInsets.all(20),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(padding: EdgeInsets.all(15)),
                  SizedBox(
                    width: 300,
                    child: Column(
                      children: [
                        Image.memory(
                          pickedFileArq != null ? imageDataCheck : imageData,
                          width: 100,
                          height: 100,
                          alignment: Alignment.topCenter,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            chooseImageArq();
                          },
                          child: Text("Selecionar Episódio"),
                        ),
                      ],
                    ),
                  ),
                  Padding(padding: EdgeInsets.all(15)),
                  SizedBox(
                      width: 300,
                      child: Column(children: [
                        Image.memory(
                          pickedFileThumb != null
                              ? pickedFileThumb!.files[0].bytes!
                              : imageData,
                          width: 100,
                          height: 100,
                          alignment: Alignment.topLeft,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            chooseImageThumb();
                          },
                          child: Text("Selecionar Thumbnail"),
                        ),
                      ]))
                ],
              ),

              Padding(
                padding: EdgeInsets.all(20),
              ),

              SizedBox(
                  width: 400,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.green),
                        child: Text("Adicionar"),
                        //color: Colors.red,
                        onPressed: () {
                          if (pickedFileArq == null) {
                            showDialog(
                              context: context,
                              builder: (context) => (AlertDialog(
                                title: Text('Opa... Faltou o episódio!'),
                                content:
                                    Text('Selecione o arquivo do podcast.'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                              )),
                            );
                          }
                          if (pickedFileThumb == null) {
                            showDialog(
                              context: context,
                              builder: (context) => (AlertDialog(
                                title: Text('Episódio sem thumbnail.'),
                                content:
                                    Text('Selecione o arquivo da thumbnail'),
                                actions: <Widget>[
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => NewData(
                                              imageData, imageDataCheck),
                                        ),
                                      );
                                    },
                                    child: Text("Ok"),
                                  ),
                                ],
                              )),
                            );
                          }
                          if (_formKey.currentState!.validate() &&
                              pickedFileArq != null &&
                              pickedFileThumb != null) {
                            addData();
                            setState(() {
                              Navigator.pop(context);
                            });
                          }
                        },
                      ),
                      Padding(padding: EdgeInsets.all(20)),
                      ElevatedButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.all(20),
                            backgroundColor: Colors.purple),
                        child: Text("Cancelar"),
                        //color: Colors.red,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
