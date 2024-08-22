import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

// Página principal para crear y seguir rutinas
class Crearrutina extends StatefulWidget {
  @override
  _RutinaCreationPageState createState() => _RutinaCreationPageState();
}

class _RutinaCreationPageState extends State<Crearrutina> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  List<Map<String, dynamic>> _createdRoutines = [];
  List<Map<String, dynamic>> _recommendedRoutines = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _loadRoutines();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _fetchRoutine() async {
    final age = _ageController.text;
    final weight = _weightController.text;
    final height = _heightController.text;

    if (age.isEmpty || weight.isEmpty || height.isEmpty) {
      _showErrorDialog(
          'La edad, peso y estatura son obligatorios para obtener una rutina recomendada.');
      return;
    }

    final url = Uri.parse(
        'https://api.api-ninjas.com/v1/exercises?age=$age&weight=$weight&height=$height');
    final response = await http.get(url, headers: {
      'X-Api-Key': 'v5FcedgLdoJXDuWWp9lG4Q==7aEUmAnYP7FW35vK'
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;

      if (data.length < 5) {
        setState(() {
          _recommendedRoutines = [];
        });
        _showErrorDialog('La API no devolvió suficientes ejercicios.');
        return;
      }

      final selectedExercises = data.take(5).map((exercise) {
        return {
          'name': exercise['name'],
          'type': exercise['type'],
          'difficulty': exercise['difficulty'],
        };
      }).toList();

      setState(() {
        _recommendedRoutines = selectedExercises;
      });
    } else {
      setState(() {
        _recommendedRoutines = [];
      });
      _showErrorDialog('Error al obtener la rutina.');
    }
  }

  void _addCustomRoutine(Map<String, dynamic> routine) async {
    final prefs = await SharedPreferences.getInstance();
    final routines = prefs.getStringList('routines') ?? [];
    routines.add(json.encode(routine));
    await prefs.setStringList('routines', routines);

    setState(() {
      _createdRoutines.add(routine);
    });
  }

  void _loadRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final routines = prefs.getStringList('routines') ?? [];

    setState(() {
      _createdRoutines =
          routines.map((r) => json.decode(r) as Map<String, dynamic>).toList();
    });
  }

  void _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('age', _ageController.text);
    await prefs.setString('weight', _weightController.text);
    await prefs.setString('height', _heightController.text);
  }

  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    _ageController.text = prefs.getString('age') ?? '';
    _weightController.text = prefs.getString('weight') ?? '';
    _heightController.text = prefs.getString('height') ?? '';
  }

  void _deleteRoutine(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final routines = prefs.getStringList('routines') ?? [];

    routines.removeAt(index);
    await prefs.setStringList('routines', routines);

    setState(() {
      _createdRoutines.removeAt(index);
    });
  }

  void _startRoutine(BuildContext context, Map<String, dynamic> routine) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetalleRutinaPage(
          exercises: routine['exercises'],
          routineName: routine['name'],
          onEjerciciosActualizados: (date, exerciseStatus) {
            // Aquí deberías implementar la lógica para actualizar los ejercicios
          },
        ),
      ),
    );
  }

  void _viewRecommendedRoutine() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RecommendedRoutinePage(
          recommendedRoutines: _recommendedRoutines,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 184, 192, 241),
        title: Text('Crear y Seguir Rutinas'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.4,
            image: AssetImage('assets/imagen 4.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Edad'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Peso (kg)'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _heightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Estatura (cm)'),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _fetchRoutine();
                      _saveUserData();
                    },
                    child: const Text('Obtener una rutina recomendada'),
                  ),
                  const SizedBox(height: 16),
                  if (_recommendedRoutines.isNotEmpty)
                    ListTile(
                      title: Text('Rutina Recomendada'),
                      subtitle: Text('5 ejercicios seleccionados para ti'),
                      trailing: Icon(Icons.arrow_forward),
                      onTap: _viewRecommendedRoutine,
                    ),
                  const SizedBox(height: 32),
                  Text('Rutinas Creadas:', textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  const Text('Presione para iniciar cualquier rutina:',
                      textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  if (_createdRoutines.isEmpty)
                    const Text(
                      'No hay rutinas creadas.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    )
                  else
                    Column(
                      children: _createdRoutines.asMap().entries.map((entry) {
                        int index = entry.key;
                        Map<String, dynamic> routine = entry.value;
                        return ListTile(
                          title: Text(routine['name']),
                          subtitle:
                              Text('${routine['exercises'].length} ejercicios'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _deleteRoutine(index);
                            },
                          ),
                          onTap: () {
                            _startRoutine(context, routine);
                          },
                        );
                      }).toList(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// Página para mostrar la rutina recomendada
class RecommendedRoutinePage extends StatefulWidget {
  final List<Map<String, dynamic>> recommendedRoutines;

  RecommendedRoutinePage({required this.recommendedRoutines});

  @override
  _RecommendedRoutinePageState createState() => _RecommendedRoutinePageState();
}

class _RecommendedRoutinePageState extends State<RecommendedRoutinePage> {
  late List<Map<String, dynamic>> _routines;
  late List<bool> _completionStatus;

  @override
  void initState() {
    super.initState();
    _routines = widget.recommendedRoutines;
    _completionStatus = List.generate(_routines.length, (_) => false);
  }

  void _updateExerciseStatus(int index) {
    setState(() {
      _completionStatus[index] = !_completionStatus[index];
    });
  }

  void _viewExerciseDetail(BuildContext context, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExerciseDetailPage2(
          exercise: _routines[index],
          onExerciseCompleted: () => _updateExerciseStatus(index),
        ),
      ),
    );
  }

  void _showSummary() {
    final completedExercises = _routines
        .asMap()
        .entries
        .where((entry) => _completionStatus[entry.key])
        .map((entry) => entry.value['name'].toString())
        .toList();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Resumen de la Rutina'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Ejercicios Completados:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ...completedExercises.map((exercise) => ListTile(
                  title: Text(exercise),
                )),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cerrar'),
            onPressed: () {
              Navigator.pop(context);
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
        title: Text('Rutina Recomendada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _routines.length,
                itemBuilder: (context, index) {
                  final exercise = _routines[index];
                  return ListTile(
                    title: Text(exercise['name']),
                    subtitle: Text('${exercise['type']} - ${exercise['difficulty']}'),
                    trailing: _completionStatus[index]
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : Icon(Icons.circle, color: Colors.grey),
                    onTap: () => _viewExerciseDetail(context, index),
                  );
                },
              ),
            ),
            ElevatedButton(
              onPressed: _showSummary,
              child: Text('Terminar Rutina'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página para mostrar detalles de un ejercicio
class ExerciseDetailPage2 extends StatelessWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onExerciseCompleted;

  ExerciseDetailPage2({required this.exercise, required this.onExerciseCompleted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise['name']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Tipo: ${exercise['type']}'),
            Text('Dificultad: ${exercise['difficulty']}'),
            ElevatedButton(
              onPressed: () {
                onExerciseCompleted();
                Navigator.pop(context);
              },
              child: Text('Marcar como completado'),
            ),
          ],
        ),
      ),
    );
  }
}

// Página para mostrar los detalles de la rutina creada
class DetalleRutinaPage extends StatelessWidget {
  final List<dynamic> exercises;
  final String routineName;
  final Function(DateTime, List<bool>) onEjerciciosActualizados;

  DetalleRutinaPage({
    required this.exercises,
    required this.routineName,
    required this.onEjerciciosActualizados,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(routineName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Detalles de la rutina:'),
            Expanded(
              child: ListView.builder(
                itemCount: exercises.length,
                itemBuilder: (context, index) {
                  final exercise = exercises[index];
                  return ListTile(
                    title: Text(exercise['name']),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
