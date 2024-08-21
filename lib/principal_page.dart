import 'package:flutter/material.dart';
import 'package:myapp/crearRutina.dart';
import 'package:myapp/calendario.dart';

class PrincipalPage extends StatefulWidget {
  const PrincipalPage({super.key});

  @override
  State<PrincipalPage> createState() => _PrincipalPageState();
}

class _PrincipalPageState extends State<PrincipalPage> {
  final _pageController = PageController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const HomeMenuPage(),
            const CalendarioPage(),
            Container(
              color: Colors.white,
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {});
            currentIndex = value;

            _pageController.jumpToPage(value);

            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );

            if (value == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Crearrutina(),
                ),
              );
            } else {
              _pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          backgroundColor: const Color.fromARGB(255, 229, 233, 240),
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.black,
          items: const [
            BottomNavigationBarItem(
              label: 'Principal',
              icon: Icon(Icons.home),
            ),
            BottomNavigationBarItem(
              label: 'Calendario',
              icon: Icon(Icons.calendar_month_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Rutina',
              icon: Icon(Icons.fitness_center_outlined),
            ),
            BottomNavigationBarItem(
              label: 'Perfil',
              icon: Icon(Icons.person),
            ),
          ],
        ),
        floatingActionButton: currentIndex == 0
            ? FloatingActionButton(
                onPressed: () {},
                child: const Icon(Icons.home),
              )
            : null);
  }
}

//pestaña del menu principal
class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("Home Menu Page cargado");
    return Container(
      color: Colors.white,
    );
  }
}
