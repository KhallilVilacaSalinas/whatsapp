import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Configuracoes extends StatefulWidget {
  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  TextEditingController _controllerNome = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  File _imagem;
  bool _subindoImagem = false;
  String _idUsuarioLogado;
  String _urlImagemRecuperada;

  Future _recuperarImagem(String origemImagem) async {
    PickedFile imagemSelecionada;
    switch (origemImagem) {
      case "camera":
        imagemSelecionada = await _picker.getImage(source: ImageSource.camera);
        break;
      case "galeria":
        imagemSelecionada = await _picker.getImage(source: ImageSource.gallery);
        break;
    }
    setState(() {
      _imagem = File(imagemSelecionada.path);
      if (_imagem != null) {
        _subindoImagem = true;
        _uploadImagem();
      }
    });
  }

  Future _uploadImagem() async {
    //Referenciar arquivo
    FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    Reference pastaRaiz = firebaseStorage.ref();
    Reference arquivo =
        pastaRaiz.child('perfil').child(_idUsuarioLogado + '.jpg');

    //Fazer upload da imagem
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
    _atualizarUrlImageFirestore(url);

    setState(() {
      _urlImagemRecuperada = url;
      print(_urlImagemRecuperada);
    });
  }

  _atualizarNomeFirestore() {
    String nome = _controllerNome.text;
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {"nome": nome};

    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

  _atualizarUrlImageFirestore(String url) {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Map<String, dynamic> dadosAtualizar = {"urlImagem": url};

    db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
  }

  //recuperar UID usuario
  _recuperarDateUsers() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = await firebaseAuth.currentUser;
    _idUsuarioLogado = user.uid;

    FirebaseFirestore db = FirebaseFirestore.instance;
    DocumentSnapshot snapshot =
        await db.collection("usuarios").doc(_idUsuarioLogado).get();

    Map<String, dynamic> dadosRecuperados = snapshot.data();
    _controllerNome.text = dadosRecuperados['nome'];

    if (dadosRecuperados["urlImagem"] != null) {
      _urlImagemRecuperada = dadosRecuperados['urlImagem'];
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDateUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  _subindoImagem ? CircularProgressIndicator() : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.grey,
                      backgroundImage: _urlImagemRecuperada != null
                          ? NetworkImage(_urlImagemRecuperada)
                          : NetworkImage(
                              "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FlatButton(
                          onPressed: () {
                            _recuperarImagem('camera');
                          },
                          child: Text('Câmera')),
                      FlatButton(
                          onPressed: () {
                            _recuperarImagem('galeria');
                          },
                          child: Text('Galeria'))
                    ],
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 8),
                    child: TextField(
                      controller: _controllerNome,
                      keyboardType: TextInputType.emailAddress,
                      style: TextStyle(fontSize: 20),
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.fromLTRB(20, 16, 32, 15),
                          hintText: "Nome",
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32))),
                      onSubmitted: (value) {},
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16, bottom: 10),
                    child: RaisedButton(
                        child: Text(
                          "Salvar",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        color: Colors.green,
                        padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        onPressed: () {
                          _atualizarNomeFirestore();
                        }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
