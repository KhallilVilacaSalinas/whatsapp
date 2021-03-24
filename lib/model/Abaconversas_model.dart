import 'package:cloud_firestore/cloud_firestore.dart';

class Conversa {
  String _nome;
  String _mensagem;
  String _caminhoFoto;
  String _idRemetente;
  String _idDestinatario;
  String _tipoMensagem;

  Conversa();

  salvar() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    await db
        .collection("conversas")
        .doc(this._idRemetente)
        .collection("ultimaConversa")
        .doc(this._idDestinatario)
        .set(this.toMap());
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = {
      "nome": this.nome,
      "mensagem": this.mensagem,
      "caminhoFoto": this.caminhoFoto,
      "idDestinatario": this.idDestinatario,
      "idRemetente": this.idRemetente,
      "tipoMensagem": this.tipoMensagem,
    };
    return map;
  }

  // ignore: unnecessary_getters_setters
  String get nome => _nome;

  // ignore: unnecessary_getters_setters
  set nome(String value) => _nome = value;

  // ignore: unnecessary_getters_setters
  String get mensagem => _mensagem;

  // ignore: unnecessary_getters_setters
  set mensagem(String value) => _mensagem = value;

  // ignore: unnecessary_getters_setters
  String get caminhoFoto => _caminhoFoto;

  // ignore: unnecessary_getters_setters
  set caminhoFoto(String value) => _caminhoFoto = value;

  String get idRemetente => _idRemetente;

  // ignore: unnecessary_getters_setters
  set idRemetente(String value) => _idRemetente = value;

  String get idDestinatario => _idDestinatario;

  // ignore: unnecessary_getters_setters
  set idDestinatario(String value) => _idDestinatario = value;

  String get tipoMensagem => _tipoMensagem;

  // ignore: unnecessary_getters_setters
  set tipoMensagem(String value) => _tipoMensagem = value;
}
