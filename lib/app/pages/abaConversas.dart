import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Abaconversas_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conversas extends StatefulWidget {
  @override
  _ConversasState createState() => _ConversasState();
}

class _ConversasState extends State<Conversas> {
  List<Conversa> listConversas;
  final _controller = StreamController<QuerySnapshot>.broadcast();
  FirebaseFirestore db = FirebaseFirestore.instance;

  String _idUsuarioLogado;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _recuperarDateUsers();
  }

  Stream<QuerySnapshot> _adicionarListenerConversas() {
    final stream = db
        .collection("conversas")
        .doc(_idUsuarioLogado)
        .collection("ultimaConversa")
        .snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  _recuperarDateUsers() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = await firebaseAuth.currentUser;
    _idUsuarioLogado = user.uid;
    print(_idUsuarioLogado);
    _adicionarListenerConversas();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _controller.stream,
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
          case ConnectionState.waiting:
            return Center(
              child: CircularProgressIndicator(),
            );
          case ConnectionState.active:
          case ConnectionState.done:
            if (snapshot.hasError) {
              Text("Erro ao carregar dados!");
            } else {
              QuerySnapshot querySnapshot = snapshot.data;

              if (querySnapshot.docs.length == 0) {
                return Center(
                    child: Text(
                  "Você ainda não tem mensagens :(",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ));
              }
              return ListView.builder(
                  itemCount: querySnapshot.docs.length,
                  itemBuilder: (_, index) {
                    List<DocumentSnapshot> conversas =
                        querySnapshot.docs.toList();
                    DocumentSnapshot item = conversas[index];

                    String urlImagem = item["caminhoFoto"];
                    String tipo = item["tipoMensagem"];
                    String mensagem = item["mensagem"];
                    String nome = item["nome"];

                    return Column(
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.fromLTRB(10, 1, 16, 1),
                          leading: CircleAvatar(
                            maxRadius: 32,
                            backgroundColor: Colors.grey,
                            backgroundImage: urlImagem != null
                                ? NetworkImage(urlImagem)
                                : null,
                          ),
                          title: Text(
                            nome,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: Text(
                            tipo == "texto" ? mensagem : "Imagem...",
                          ),
                        ),
                        Divider(
                          indent: 65,
                          color: Colors.grey[350],
                        )
                      ],
                    );
                  });
            }
        }
      },
    );
  }
}
