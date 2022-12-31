class Episodio {
  String programa;
  String titulo;
  String dia;
  String duracao;
  String arq;
  String thumb;

  Episodio(
      {required this.programa,
      required this.titulo,
      required this.dia,
      required this.duracao,
      required this.arq,
      required this.thumb});

  factory Episodio.fromJson(Map<String, dynamic> jsonData) {
    return Episodio(
      programa: jsonData['programa'],
      titulo: jsonData['titulo'],
      dia: jsonData['dia'],
      duracao: jsonData['duracao'],
      arq: "http://localhost/semviolencia/eps/" + jsonData['arq'],
      thumb: "http://localhost/semviolencia/thumb/" + jsonData['thumb'],
    );
  }
}
