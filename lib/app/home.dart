import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/app/pages/abaContatos.dart';
import 'package:whatsapp/app/pages/abaConversas.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  List<String> itensMenu = ['Configurações', 'Deslogar'];

  // ignore: unused_field
  String _recuperarUsuario = '';

  Future _recuperarDadosUsuarios() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    User userLogado = await auth.currentUser;

    setState(() {
      _recuperarUsuario = userLogado.email;
    });
  }

  _escolhaMenuItem(String escolhaUsuario) {
    switch (escolhaUsuario) {
      case 'Configurações':
        Navigator.pushNamed(context, '/config');
        break;
      case 'Deslogar':
        _deslogarusuario();
        break;
    }
  }

  _deslogarusuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.popAndPushNamed(context, '/');
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    User user = await auth.currentUser;
    if (user == null) {
      Navigator.popAndPushNamed(context, '/');
    }
  }

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuarios();
    _verificarUsuarioLogado();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff075E54),
          title: Text('Whatsapp'),
          bottom: TabBar(
            indicatorWeight: 4,
            labelStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            controller: _tabController,
            indicatorColor: Colors.white,
            tabs: [
              Tab(
                text: 'Conversas',
              ),
              Tab(
                text: 'Contatos',
              )
            ],
          ),
          actions: <Widget>[
            PopupMenuButton<String>(
              onSelected: _escolhaMenuItem,
              itemBuilder: (context) {
                return itensMenu.map((String item) {
                  return PopupMenuItem<String>(
                    value: item,
                    child: Text(item),
                  );
                }).toList();
              },
            )
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: [Conversas(), Contatos()],
        )
        // Container(
        //   child: Center(
        //     child: Column(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: [
        //         Text(
        //           _recuperarUsuario,
        //         ),
        //         SizedBox(
        //           height: 40,
        //         ),
        //         RaisedButton(
        //           child: Text(
        //             "Sair",
        //             style: TextStyle(color: Colors.black, fontSize: 20),
        //           ),
        //           onPressed: () {
        //             _sair();
        //             Navigator.popAndPushNamed(context,'/'); //Passar o context para não abrir tela preta
        //           },
        //         )
        //       ],
        //     ),
        //   ),
        // ),
        );
  }
}
