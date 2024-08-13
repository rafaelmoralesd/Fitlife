import 'package:flutter/material.dart';
import 'package:myapp/inputs_page.dart';
import 'package:myapp/principal_page.dart';
import 'package:myapp/registrar_page.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Compemnts App',
      // home: HomePage(),
      initialRoute: 'inicio', //esta es la ruta principal
      routes: {
        'registrar': (context) => RegistrarPage(),
        'inicio': (context) => InputsPage(),
        'principal': (context) => const PrincipalPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => PageNotFound(ruta: settings.name),
        );
      },
    );
  }
}

class HomePage {
  const HomePage();
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({
    super.key,
    this.ruta = 'No-found',
  });

  final String? ruta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('La ruta "$ruta" no existe')));
  }
}
