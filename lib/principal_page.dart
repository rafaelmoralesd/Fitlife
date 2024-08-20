import 'package:flutter/material.dart';
import 'package:myapp/crearRutina.dart';

import 'package:table_calendar/table_calendar.dart';

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
            const CalendarioPage(),
            Container(color: Colors.white,),
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
                builder: (context) =>  Crearrutina(),
              ),
            );
          } else {
            // Si no, navega usando el PageView
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
    return Container(color: Colors.white,);
  }
}

//pestaña de calendario
class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;

  DateTime ahora = DateTime.now();
  DateTime? _diaseleccionado;
  Map<DateTime, List<dynamic>> eventos = {};

  void _diaSeleccionado(DateTime dia, DateTime focusedDay) {
    setState(() {
      ahora = dia;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 36),
          TableCalendar(
            headerStyle: const HeaderStyle(
              titleCentered: true,
              formatButtonVisible: false,
            ),
            availableGestures: AvailableGestures.all,
            focusedDay: ahora,
            selectedDayPredicate: (hoy) => isSameDay(hoy, ahora),
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            onDaySelected: _diaSeleccionado,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarFormat: _calendarFormat,
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              selectedTextStyle: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              todayDecoration: const BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              todayTextStyle: const TextStyle(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              outsideDaysVisible: false,
            ),
          ),
        ],
      ),
    );
  }
}
