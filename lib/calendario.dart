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
        if (eventos[_diaseleccionado] == null) {
          eventos[_diaseleccionado!] = [];
        }
        eventos[_diaseleccionado!]!.add(Eventos(_eventController.text));
        _eventoseleccionado.value = _getevents(_diaseleccionado!);
      });
      _eventController.clear();
      Navigator.of(context).pop();
    }
  }

  Color _getDayColor(DateTime day) {
    List<Eventos> dayEvents = _getevents(day);
    int totalEjercicios = 5;
    int ejerciciosRealizados = dayEvents.length;

    if (ejerciciosRealizados == 0) {
      return const Color.fromARGB(255, 255, 255, 255);
    } else if (ejerciciosRealizados > 0 &&
        ejerciciosRealizados < totalEjercicios) {
      return Colors.yellowAccent;
    } else {
      return Colors.greenAccent;
    }
  }

  Color _getSelectedDayColor(DateTime day) {
    Color baseColor = _getDayColor(day);
    return baseColor.withOpacity(0.5);
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
                title: const Text('Ejercicio que realizo:'),
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
              outsideDaysVisible: false,
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: _getSelectedDayColor(_diaseleccionado!),
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              cellMargin: const EdgeInsets.all(6),
            ),
            calendarBuilders: CalendarBuilders(
              defaultBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getDayColor(day),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
              selectedBuilder: (context, day, focusedDay) {
                return Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _getSelectedDayColor(day),
                  ),
                  child: Center(
                    child: Text(
                      '${day.day}',
                      style: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'No se realizaron ejercicios',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.yellowAccent,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Se hicieron algunos ejercicios',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                Row(
                  children: [
                    Container(
                      width: 20,
                      height: 20,
                      color: Colors.greenAccent,
                    ),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: Text(
                        'Se completaron todos los ejercicios',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
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
