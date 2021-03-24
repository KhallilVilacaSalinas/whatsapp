import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:whatsapp/model/Abaconversas_model.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:whatsapp/model/mensagens_model.dart';

class Mensagens extends StatefulWidget {
  Usuario contato;

  Mensagens(this.contato);

  @override
  _MensagensState createState() => _MensagensState();
}

class _MensagensState extends State<Mensagens> {
  TextEditingController _controllerMensagens = TextEditingController();
  FirebaseFirestore db = FirebaseFirestore.instance;
  String _idUsuarioLogado;
  String _idUsuarioDestinatario;
  File _imagem;
  bool _subindoImagem = false;

  @override
  void initState() {
    super.initState();
    _recuperarDateUsers();
  }

  _recuperarDateUsers() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = firebaseAuth.currentUser;
    _idUsuarioLogado = user.uid;
    _idUsuarioDestinatario = widget.contato.idUsuario;
    print(_idUsuarioLogado);
    print(_idUsuarioDestinatario);
  }

  _salvarMensagem(
      String idRemetente, String idDestinatario, MensagemUser msg) async {
    await db
        .collection("mensagens")
        .doc(idRemetente)
        .collection(idDestinatario)
        .add(msg.toMap());
    _controllerMensagens.clear();
  }

  _enviarMensagem() {
    String textMensagem = _controllerMensagens.text;
    if (textMensagem.isNotEmpty) {
      MensagemUser mensagem = MensagemUser();
      mensagem.idUsuario = _idUsuarioDestinatario;
      mensagem.mensagem = textMensagem;
      mensagem.urlImagem = "";
      mensagem.data = Timestamp.now().toString();
      mensagem.tipo = "texto";

      //salvar mensagem para o remetente
      _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
      //salvar mensagem para o destinatario
      _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

      _salvarConversa(mensagem);
    }
  }

  _enviarFoto() async {
    final ImagePicker _picker = ImagePicker();

    PickedFile imagemSelecionada;
    imagemSelecionada = await _picker.getImage(source: ImageSource.gallery);

    String nomeImagem = DateTime.now().microsecondsSinceEpoch.toString();
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference pastaRaiz = firebaseStorage.ref();
    Reference arquivo = pastaRaiz
        .child('mensagens')
        .child(_idUsuarioLogado)
        .child(nomeImagem + '.jpg');

    //Fazer upload da imagem
    _imagem = File(imagemSelecionada.path);
    UploadTask task = arquivo.putFile(_imagem);

    //Controlar progresso do upload
    task.snapshotEvents.listen((TaskSnapshot storageEvent) {
      if (storageEvent.state == TaskState.running) {
        setState(() {
          _subindoImagem = true;
        });
      } else if (storageEvent.state == TaskState.success) {
        setState(() {
          _subindoImagem = false;
        });
      }
    });

    //Recuperando url da imagem
    task.then((TaskSnapshot snapshot) => _recuperarUrlImagem(snapshot));
  }

  Future _recuperarUrlImagem(TaskSnapshot snapshot) async {
    String url = await snapshot.ref.getDownloadURL();

    MensagemUser mensagem = MensagemUser();
    mensagem.idUsuario = _idUsuarioDestinatario;
    mensagem.mensagem = "";
    mensagem.urlImagem = url;
    mensagem.data = Timestamp.now().toString();
    mensagem.tipo = "imagem";

    //salvar mensagem para o remetente
    _salvarMensagem(_idUsuarioLogado, _idUsuarioDestinatario, mensagem);
    //salvar mensagem para o destinatario
    _salvarMensagem(_idUsuarioDestinatario, _idUsuarioLogado, mensagem);

    _salvarConversa(mensagem);
  }

  _salvarConversa(MensagemUser msg) {
    //Salvar conversa remetente
    Conversa cRemetente = Conversa();
    cRemetente.idRemetente = _idUsuarioLogado;
    cRemetente.idDestinatario = _idUsuarioDestinatario;
    cRemetente.mensagem = msg.mensagem;
    cRemetente.nome = widget.contato.nome;
    cRemetente.caminhoFoto = widget.contato.urlImagem;
    cRemetente.tipoMensagem = msg.tipo;
    cRemetente.salvar();

    //Salvar conversa destinatario

    Conversa cDestinatario = Conversa();
    cDestinatario.idRemetente = _idUsuarioDestinatario;
    cDestinatario.idDestinatario = _idUsuarioLogado;
    cDestinatario.mensagem = msg.mensagem;
    cDestinatario.nome = widget.contato.nome;
    cDestinatario.caminhoFoto = widget.contato.urlImagem;
    cDestinatario.tipoMensagem = msg.tipo;
    cDestinatario.salvar();
  }

  _recuperarMensagens() async {
    await db
        .collection("mensagens")
        .doc(_idUsuarioLogado)
        .collection(_idUsuarioDestinatario)
        .snapshots();
    print("ERRO : " + _idUsuarioDestinatario);
  }

  @override
  Widget build(BuildContext context) {
    var caixaMensagens = Container(
      padding: EdgeInsets.all(2),
      child: Row(
        children: [
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(right: 8),
            child: TextField(
              controller: _controllerMensagens,
              obscureText: false,
              keyboardType: TextInputType.text,
              style: TextStyle(fontSize: 17),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.fromLTRB(20, 10, 0, 15),
                  hintText: "Digite uma mensagem",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(40)),
                  prefixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () => _enviarFoto(),
                  )),
              onSubmitted: (value) {},
            ),
          )),
          FloatingActionButton(
            backgroundColor: Color(0xff1ebea5),
            child: Icon(
              Icons.send,
              color: Colors.white,
            ),
            mini: true,
            onPressed: () {
              _enviarMensagem();
            },
          )
        ],
      ),
    );

    var stream = StreamBuilder(
      stream: db
          .collection("mensagens")
          .doc(_idUsuarioLogado == null ? "SEM VALOR" : _idUsuarioLogado)
          .collection(_idUsuarioDestinatario == null
              ? "SEM VALOR"
              : _idUsuarioDestinatario)
          .snapshots(),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
            break;
          case ConnectionState.active:
          case ConnectionState.done:
            QuerySnapshot querySnapshot = snapshot.data;
            print("data: " + snapshot.data.toString());

            if (snapshot.hasError) {
              return Expanded(child: Text("Erro ao carregar dados"));
            } else {
              return Expanded(
                  child: ListView.builder(
                itemCount: querySnapshot.docs.length,
                itemBuilder: (context, index) {
                  List<DocumentSnapshot> mensagens =
                      querySnapshot.docs.toList();
                  DocumentSnapshot item = mensagens[index];
                  Alignment alinhamento = Alignment.bottomRight;
                  Color cor = Color(0xffd2ffa5);
                  if (_idUsuarioLogado != item["idUsuario"]) {
                    alinhamento = Alignment.bottomLeft;
                    cor = Colors.white;
                  }

                  return Align(
                    alignment: alinhamento,
                    child: Padding(
                      padding: EdgeInsets.all(6),
                      child: Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                            color: cor,
                            borderRadius: BorderRadius.all(Radius.circular(8))),
                        child: Column(
                          children: [
                            item["tipo"] == "texto"
                                ? Text(item["mensagem"])
                                : Image.network(
                                    item["urlImagem"],
                                  )
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ));
            }
            break;
        }
      },
    );

    String url = widget.contato.urlImagem;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              maxRadius: 25,
              backgroundColor: Colors.grey,
              backgroundImage: url != null
                  ? NetworkImage(url)
                  : NetworkImage(
                      "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png"),
            ),
            SizedBox(
              width: 10,
            ),
            Text(widget.contato.nome)
          ],
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/images/bg.png'), fit: BoxFit.cover)),
        child: SafeArea(
            child: Container(
          padding: EdgeInsets.all(8),
          child: Column(
            children: [stream, caixaMensagens],
          ),
        )),
      ),
    );
  }
}
