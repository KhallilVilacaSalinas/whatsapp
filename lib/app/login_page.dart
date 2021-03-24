import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:whatsapp/model/usuario.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  
  String _mensagemErro = "";

  _validarCapos() async {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains('@')) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        
        usuario.email = email;
        usuario.senha = senha;

       _logarUsuario(usuario);
      } else {
        setState(() {
          _mensagemErro = "Preencha a senha.";
        });
      }
    } else {
      setState(() {
        _mensagemErro = "Preencha o email.";
      });
    }
  }

  _logarUsuario(Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
            email: usuario.email, 
            password: usuario.senha)
        .then((firebsaeUser) {
      
      Navigator.popAndPushNamed(context, '/home'); //Passar o context para não abrir tela preta
    }).catchError((onError) {
      setState(() {
        _mensagemErro = 'Erro ao autenticar usuário.';
        print('erro : ' + onError.toString());
      });
    });
  }

  Future _verificarUsuarioLogado() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    // ignore: await_only_futures
    User user = await auth.currentUser;
    if (user != null) {
      Navigator.popAndPushNamed(context, '/home');
    }
  }

  @override
  void initState() {
    super.initState();
    _verificarUsuarioLogado();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Container(
            decoration: BoxDecoration(color: Color(0xff075E54)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 32),
                        child: Image.asset(
                          'assets/images/logo.png',
                          height: 150,
                          width: 200,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: TextField(
                          controller: _controllerEmail,
                          keyboardType: TextInputType.emailAddress,
                          style: TextStyle(fontSize: 20),
                          decoration: InputDecoration(
                              contentPadding:
                                  EdgeInsets.fromLTRB(20, 16, 32, 15),
                              hintText: "E-mail",
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32))),
                          onSubmitted: (value) {},
                        ),
                      ),
                      TextField(
                        controller: _controllerSenha,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        style: TextStyle(fontSize: 20),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.fromLTRB(20, 16, 32, 15),
                            hintText: "Senha",
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(32))),
                        onSubmitted: (value) {},
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 16, bottom: 10),
                        child: RaisedButton(
                            child: Text(
                              "Entrar",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                            color: Colors.green,
                            padding: EdgeInsets.fromLTRB(32, 16, 32, 16),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(32)),
                            onPressed: () {
                              _validarCapos();
                            }),
                      ),
                      Center(
                        child: GestureDetector(
                          child: Text("Não tem conta? cadastre-se!",
                              style: TextStyle(color: Colors.white)),
                          onTap: () {
                            _controllerEmail.text = "";
                            _controllerSenha.text = "";
                            setState(() {
                              _mensagemErro = "";
                            });
                            Navigator.of(context).pushReplacementNamed('/cadastro');
                          },
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _mensagemErro,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16),
                            ),
                          ]),
                    ],
                  ),
                ),
              ),
            )),
      ),
    );
  }
}
