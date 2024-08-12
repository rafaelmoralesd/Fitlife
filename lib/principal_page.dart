import 'package:flutter/material.dart';

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
          // ⬇️ Para desabilitar el swipe
          physics: const NeverScrollableScrollPhysics(),
          // onPageChanged: (value) {
          //   setState(() {});
          //   currentIndex = value;
          // },
          children: [
            const HomeMenuPage(),
            Container(color: Color.fromARGB(255, 4, 230, 255)),
            Container(color: Color.fromARGB(255, 4, 230, 255)),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (value) {
            setState(() {});
            currentIndex = value;

            // _pageController.jumpToPage(value);

            _pageController.animateToPage(
              value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          },
          backgroundColor: Colors.blueAccent,
          selectedItemColor: Colors.white,
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

class HomeMenuPage extends StatelessWidget {
  const HomeMenuPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print("Home Menu Page cargado");
    return Container(color: Color.fromARGB(255, 4, 230, 255));
  }
}
