import 'package:flutter/material.dart';
import 'package:whatsapp/app/cadastro_page.dart';
import 'package:whatsapp/app/home.dart';
import 'package:whatsapp/app/login_page.dart';
import 'package:whatsapp/app/pages/NotFound.dart';
import 'package:whatsapp/app/pages/configuracoes.dart';
import 'package:whatsapp/app/pages/mensagens.dart';

class RouteGenerator {
  // ignore: missing_return
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => LoginPage(),
        );
      case '/cadastro':
        return MaterialPageRoute(
          builder: (_) => CadastroPage(),
        );
      case '/home':
        return MaterialPageRoute(
          builder: (_) => HomePage(),
        );
      case '/config':
        return MaterialPageRoute(
          builder: (_) => Configuracoes(),
        );
      case '/mensagens':
        return MaterialPageRoute(
          builder: (_) => Mensagens(args),
        );
      default:
        _erroRota();
    }
  }

  static Route<dynamic> _erroRota() {
    return MaterialPageRoute(
      builder: (_) => NotFound(),
    );
  }
}
