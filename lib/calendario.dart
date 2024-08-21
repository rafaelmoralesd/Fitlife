// lib/calendario.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:myapp/DetalleRutinaPage.dart';
import 'package:myapp/eventos.dart';

class CalendarioPage extends StatefulWidget {
  const CalendarioPage({super.key});

  @override
  _CalendarioPageState createState() => _CalendarioPageState();
}

class _CalendarioPageState extends State<CalendarioPage> {
  final CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime ahora = DateTime.now();
  DateTime? _diaseleccionado;
  Map<DateTime, List<int>> ejercicios = {}; // Estado local para ejercicios
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
    return []; // Implementar lógica si es necesario
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
      // Implementar lógica para agregar eventos si es necesario
      _eventController.clear();
      Navigator.of(context).pop();
    }
  }

  void _actualizarEjercicios(DateTime fecha, List<int> ejerciciosRealizados) {
    setState(() {
      ejercicios[fecha] = ejerciciosRealizados;
    });
  }

  Color _getDayColor(DateTime day) {
    List<int> ejerciciosRealizados = ejercicios[day] ?? [];
    int totalEjercicios = 5; // Número total de ejercicios por día
    int ejerciciosCompletos = ejerciciosRealizados.length;

    if (ejerciciosCompletos == 0) {
      return Colors.redAccent; // No se realizaron ejercicios
    } else if (ejerciciosCompletos > 0 &&
        ejerciciosCompletos < totalEjercicios) {
      return Colors.yellowAccent; // Se hicieron algunos, pero no todos
    } else {
      return Colors.greenAccent; // Se completaron todos los ejercicios
    }
  }

  Color _getSelectedDayColor(DateTime day) {
    Color baseColor = _getDayColor(day);
    return baseColor
        .withOpacity(0.5); // Color del día seleccionado con transparencia
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendario'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => DetalleRutinaPage(
                exercises: [], // Pasa los datos necesarios
                routineName: '', // Pasa los datos necesarios
                onEjerciciosActualizados:
                    _actualizarEjercicios, // Agregamos el callback
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
