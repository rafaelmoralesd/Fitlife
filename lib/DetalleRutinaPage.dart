import 'package:flutter/material.dart';
import 'package:myapp/ExerciseDetailPage.dart'; // Asegúrate de que el import sea correcto

class DetalleRutinaPage extends StatefulWidget {
  final List<dynamic> exercises;
  final String routineName;
  final Function(DateTime, List<int>)
      onEjerciciosActualizados; // Agregamos el callback

  const DetalleRutinaPage({
    Key? key,
    required this.exercises,
    required this.routineName,
    required this.onEjerciciosActualizados, // Inicializamos el callback
  }) : super(key: key);

  @override
  _DetalleRutinaPageState createState() => _DetalleRutinaPageState();
}

class _DetalleRutinaPageState extends State<DetalleRutinaPage> {
  List<bool> _completedExercises = [];

  @override
  void initState() {
    super.initState();
    _completedExercises = List<bool>.filled(widget.exercises.length, false);
  }

  void _markAsCompleted(int index) {
    setState(() {
      _completedExercises[index] = true;
    });
  }

  void _finishRoutine() {
    final completedCount =
        _completedExercises.where((completed) => completed).length;
    final totalExercises = widget.exercises.length;

    // Aquí necesitamos pasar la información al callback
    widget.onEjerciciosActualizados(
        DateTime.now(),
        List<int>.generate(
            totalExercises, (index) => _completedExercises[index] ? 1 : 0));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resumen de Rutina'),
        content: Text(
            'Has completado $completedCount de $totalExercises ejercicios.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Regresar a la página de calendario
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalles de la Rutina: ${widget.routineName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: widget.exercises.length,
              itemBuilder: (context, index) {
                final exercise = widget.exercises[index];
                return ListTile(
                  leading: Icon(Icons.fitness_center),
                  trailing: Checkbox(
                    value: _completedExercises[index],
                    onChanged: (value) {
                      setState(() {
                        _completedExercises[index] = value!;
                      });
                    },
                  ),
                  title: Text(exercise['name']),
                  subtitle: Text(
                      '${exercise['duration']} minutos\n${exercise['description']}'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ExerciseDetailPage(
                          exerciseName: exercise['name'],
                          duration: exercise['duration'],
                          description: exercise['description'],
                          onComplete: (name) {
                            _markAsCompleted(index);
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _finishRoutine,
              child: Text('Terminar Rutina'),
            ),
          ),
        ],
      ),
    );
  }
}
