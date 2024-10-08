import 'package:flutter/material.dart';
import 'package:myapp/ExerciseDetailPage.dart';
import 'package:myapp/calendario.dart'; // Asegúrate de que el import sea correcto

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
      Color color = Colors.transparent;
    if (_completedExercises.every((completed) => completed)) {
      color = Colors.green;
    } 
    if (!_completedExercises.any((completed) => completed)) {
      color = Colors.yellow;
    }

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
            child: const Text('OK'),
            onPressed: () {
              Navigator.pop(context);
               Navigator.push(context, MaterialPageRoute(builder: (context) => CalendarioPage()));
              
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
        backgroundColor: const Color.fromARGB(255, 216, 200, 151),
        title: Text('Detalles de la Rutina: ${widget.routineName}'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
          decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.4,
                  image: AssetImage('assets/imagen8.png'),
                  fit: BoxFit.cover,
                ),
              ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: widget.exercises.length,
                itemBuilder: (context, index) {
                  final exercise = widget.exercises[index];
                  return ListTile(
                    leading: Icon(Icons.fitness_center),
                    trailing: IgnorePointer(
                      ignoring: true,
                      child: Checkbox(
                        value: _completedExercises[index],
                        onChanged: (value) {
                          setState(() {
                            _completedExercises[index] = value!;
                          });
                        },
                      ),
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
            SizedBox(height: 16),
            Text(
              'Completa al menos 1 ejercicio para terminar la rutina:',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed:
                    _completedExercises.any((completed) => completed)
                        ? _finishRoutine
                        : null,
                        

              
                  
                child: const Text('Terminar Rutina'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
