import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/Usuario.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Contatos extends StatefulWidget {
  @override
  _ContatosState createState() => _ContatosState();
}

class _ContatosState extends State<Contatos> {
  String _idUsuarioLogado;
  String _email;

  Future<List<Usuario>> _recuperarContatos() async {
    FirebaseFirestore db = FirebaseFirestore.instance;
    QuerySnapshot querySnapshot = await db.collection("usuarios").get();

    List<Usuario> listaUsersRecup = List();
    for (DocumentSnapshot item in querySnapshot.docs) {
      var dados = item.data();
      if (dados["email"] == _email) continue;

      Usuario usuario = Usuario();
      usuario.idUsuario = item.id;
      usuario.nome = dados["nome"];
      usuario.email = dados["email"];
      usuario.urlImagem = dados["urlImagem"];

      listaUsersRecup.add(usuario);
    }
    return listaUsersRecup;
  }

  _recuperarDateUsers() async {
    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    User user = await firebaseAuth.currentUser;
    _idUsuarioLogado = user.uid;
    _email = user.email;
  }

  @override
  void initState() {
    super.initState();
    _recuperarDateUsers();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Usuario>>(
      future: _recuperarContatos(),
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
            return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (_, indice) {
                  List<Usuario> listaItens = snapshot.data;
                  Usuario usuario = listaItens[indice];
                  return Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "/mensagens",
                              arguments: usuario);
                        },
                        contentPadding: EdgeInsets.fromLTRB(10, 1, 16, 1),
                        leading: CircleAvatar(
                            maxRadius: 32,
                            backgroundColor: Colors.grey,
                            backgroundImage: usuario.urlImagem != null
                                ? NetworkImage(usuario.urlImagem)
                                : NetworkImage(
                                    "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png")),
                        title: Text(
                          usuario.nome,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      Divider(
                        indent: 65,
                        color: Colors.grey[350],
                      )
                    ],
                  );
                });
            break;
        }
      },
    );
  }
}
