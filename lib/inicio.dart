import 'package:flutter/material.dart';

//pestaña del menu principal
class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("Home Menu Page cargado");
    return Scaffold(
      backgroundColor: Colors.pink[50],
      appBar: AppBar(
        title: Text('FitLife', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.pink[50],
        elevation: 0,
      ),
      body: Stack(
        /*decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.4,
                  image: AssetImage('assets/imagen 4.jpg'),
                  fit: BoxFit.cover,
                ),
              ), */

        children: [
          Positioned.fill(
            child: Center(
              child: Opacity(
                opacity: 0.4,
                child: Image.asset(
                  'assets/imagen5.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Cree su plan',
                                  style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 10.0),
                              Text('Crear', style: TextStyle(fontSize: 16.0)),
                            ],
                          ),
                        ),
                        SizedBox(width: 16.0),
                        //     ClipRRect(
                        //       borderRadius: BorderRadius.circular(16.0),
                        //       child: Opacity(
                        //         opacity: 0.5,
                        //         child: Image.asset(
                        //           'assets/imagen5.png',
                        //           width: 80.0,
                        //           height: 80.0,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       ),
                        //     ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: Text('Calendario', style: TextStyle(fontSize: 18.0)),
                  ),
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text('Mis Rutinas',
                              style: TextStyle(fontSize: 18.0)),
                        ),
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Text('Comenzar a Entrenar',
                              style: TextStyle(fontSize: 18.0)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                    child: const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bienvenido de nuevo',
                            style: TextStyle(fontSize: 18.0)),
                        SizedBox(height: 8.0),
                        Text('¿Quieres comenzar a entrenar ya?',
                            style: TextStyle(fontSize: 16.0)),
                        Text('¿Quieres crear otro plan?',
                            style: TextStyle(fontSize: 16.0)),
                        Text(
                            'Si tu respuesta fue si ve a la pestaña de Rutinas y crea otra rutina',
                            style: TextStyle(fontSize: 16.0)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
