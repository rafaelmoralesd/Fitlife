import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  DateTime ahora = DateTime.now();
  DateTime? _diaseleccionado;

  // Map para almacenar los días con flecha de aprobación
  Map<DateTime, bool> _diasConAprobacion = {};

  @override
  void initState() {
    super.initState();
    _diaseleccionado = ahora;
  }

  void _diaSeleccionado(DateTime dia) {
    setState(() {
      _diaseleccionado = dia;
    });
  }

  void _agregarFlechaDeAprobacion() {
    if (_diaseleccionado != null) {
      setState(() {
        // Agregar el ícono de aprobación al día seleccionado
        _diasConAprobacion[_diaseleccionado!] = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 223, 150, 178),
        title: const Text('Calendario'),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.4,
            image: AssetImage('assets/fitlife2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 16),
            TableCalendar(
              focusedDay: DateTime.now(),
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              calendarBuilders: CalendarBuilders(
                todayBuilder: (context, day, focusedDay) {
                  bool hasApproval = _diasConAprobacion.containsKey(day);
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hasApproval)
                          Positioned(
                            bottom: 4,
                            child: Icon(
                              Icons.check,
                              color: Colors.green,
                              size: 20.0,
                            ),
                          ),
                      ],
                    ),
                  );
                },
                selectedBuilder: (context, day, focusedDay) {
                  bool hasApproval = _diasConAprobacion.containsKey(day);
                  return Container(
                    margin: const EdgeInsets.all(6.0),
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (hasApproval)
                          Positioned(
                            bottom: 4,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 20.0,
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                ),
                outsideDaysVisible: false,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                _diaSeleccionado(selectedDay);
              },
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: _agregarFlechaDeAprobacion,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check, size: 16.0),
                    const SizedBox(width: 8.0),
                    Text("Agregar Flecha"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Aquí puedes agregar la lógica para ir a otra página
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
