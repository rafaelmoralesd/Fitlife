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
  Map<DateTime, List<Eventos>> eventos = {};
  TextEditingController _eventController = TextEditingController();
  late final ValueNotifier<List<Eventos>> _eventoseleccionado;

  @override
  void initState() {
    super.initState();
    _diaseleccionado = ahora;
    _eventoseleccionado = ValueNotifier(_getevents(_diaseleccionado!));
  }

  @override
  void dispose() {
    _eventController.dispose();
    _eventoseleccionado.dispose();
    super.dispose();
  }

  List<Eventos> _getevents(DateTime day) {
    return eventos[day] ?? [];
  }

  void _diaSeleccionado(DateTime dia, DateTime focusedDay) {
    setState(() {
      ahora = dia;
      _diaseleccionado = dia;
      _eventoseleccionado.value = _getevents(dia);
    });
  }

  void _agregarEvento() {
    if (_diaseleccionado != null && _eventController.text.isNotEmpty) {
      setState(() {
        // Añadir el evento al día seleccionado
        if (eventos[_diaseleccionado] == null) {
          eventos[_diaseleccionado!] = [];
        }
        eventos[_diaseleccionado!]!.add(Eventos(_eventController.text));

        // Actualizar la lista de eventos seleccionados
        _eventoseleccionado.value = _getevents(_diaseleccionado!);
      });
      _eventController.clear();
      Navigator.of(context).pop();
    }
  }

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
                title: const Text('Nombre del evento'),
                content: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _eventController,
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: _agregarEvento,
                    child: const Text('Agregar'),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
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
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Eventos>>(
              valueListenable: _eventoseleccionado,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Colors.blueAccent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 3,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Text(
                        value[index].titulo,
                        style: const TextStyle(fontSize: 16),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
