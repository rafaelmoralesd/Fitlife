import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/eventos.dart';

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
  TextEditingController _eventController = TextEditingController();
  // late final ValueNotifier<list<Eventos>> _eventoseleccionado;

  void _diaSeleccionado(DateTime dia, DateTime focusedDay) {
    setState(() {
      ahora = dia;
    });
  }

  @override
  void initState() {
    super.initState();
    // _eventoseleccionado = ValueNotifier(_getevents(_diaseleccionado));
  }

  @override
  void dispose() {
    super.dispose();
  }
/*List<Eventos> _getevents(DateTime day) {
    return eventos[day]??[];
  }
*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  scrollable: true,
                  title: Text('Nombre del evento'),
                  content: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      controller: _eventController,
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: () {
                        eventos.addAll({
                          _diaseleccionado!: [Eventos(_eventController.text)]
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text('Agregar'),
                    )
                  ],
                );
              });
        },
        child: Icon(Icons.add),
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
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
            /*
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              focusedDay = focusedDay;
            },*/
          ),
          const SizedBox(height: 8.0)
        ],
      ),
    );
  }
}
