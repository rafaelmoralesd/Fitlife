import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/CustomRoutinePage.dart';
import 'package:myapp/DetalleRutinaPage.dart';
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
    final response = await http.get(url,
        headers: {'X-Api-Key': 'v5FcedgLdoJXDuWWp9lG4Q==7aEUmAnYP7FW35vK'});

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
  void _clearText() {
  _heightController.clear();
  _weightController.clear();
  _ageController.clear();
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
                      _clearText();
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
                    ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomRoutinePage(
                            onSaveRoutine: (routine) {
                              _addCustomRoutine(routine);
                            },
                          ),
                        ),
                      );
                      _saveUserData();
                    },
                    child: Text('Crear Rutina Personalizada'),
                  ),
                  const SizedBox(height: 16),
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
        backgroundColor: const Color.fromARGB(255, 216, 200, 151),
        title: Text('Rutina Recomendada'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            opacity: 0.4,
            image: AssetImage('assets/imagen8.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
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
                      subtitle:
                          Text('${exercise['type']} - ${exercise['difficulty']}'),
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
      ),
    );
  }
}

class ExerciseDetailPage2 extends StatefulWidget {
  final Map<String, dynamic> exercise;
  final VoidCallback onExerciseCompleted;

  ExerciseDetailPage2({required this.exercise, required this.onExerciseCompleted});

  @override
  _ExerciseDetailPage2State createState() => _ExerciseDetailPage2State();
}

class _ExerciseDetailPage2State extends State<ExerciseDetailPage2> {
  Timer? _timer;
  int _remainingTime = 180; // 3 minutos en segundos
  double _progress = 1.0;
  bool _exerciseCompleted = false;
  bool _canComplete = false;
  String _instructions = 'Cargando instrucciones...';
  String _imageUrl = ''; // URL de la imagen del ejercicio

  @override
  void initState() {
    super.initState();
    _fetchInstructions();
    _fetchImage();
  }

  void _startTimer() {
    if (_timer != null) {
      _timer!.cancel();
    }

    setState(() {
      _exerciseCompleted = false;
      _canComplete = false;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
          _progress = _remainingTime / 180;
        } else {
          _exerciseCompleted = true;
          _canComplete = true;
          _timer!.cancel();
        }
      });
    });
  }

  Future<void> _fetchInstructions() async {
     final  exerciseType = widget.exercise['type'];
    final exerciseName = widget.exercise['name'];
    final url = Uri.parse('https://api.api-ninjas.com/v1/exercises?$exerciseType=$exerciseName');
    final response = await http.get(url, headers: {
      'X-Api-Key': 'v5FcedgLdoJXDuWWp9lG4Q==7aEUmAnYP7FW35vK', // Clave de API
    });

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List<dynamic>;

      if (data.isNotEmpty) {
        setState(() {
          _instructions = data[0]['instructions'] ?? 'No se encontraron instrucciones.';
        });
      } else {
        setState(() {
          _instructions = 'No se encontraron instrucciones.';
        });
      }
    } else {
      setState(() {
        _instructions = 'Error al cargar las instrucciones.';
      });
    }
  }

 Future<void> _fetchImage() async {
    final exerciseName = widget.exercise['name'];
    final searchQuery = Uri.encodeComponent(exerciseName + ' exercise'); // Mejorar precisión en la búsqueda
    final url = Uri.parse('https://api.unsplash.com/search/photos?query=$searchQuery&client_id=cwiyNtUMEtaPg-zHbNPvHnctqLj-Umx9Ik7q8VrKrh4');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['results'].isNotEmpty) {
        setState(() {
          _imageUrl = data['results'][0]['urls']['regular'] ?? ''; // Ajusta esto según la respuesta de la API
        });
      } else {
        setState(() {
          _imageUrl = ''; // Sin imagen relevante
        });
      }
    } else {
      setState(() {
        _imageUrl = ''; // Sin imagen relevante
      });
    }
  }



  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 216, 200, 151),
        title: Text(widget.exercise['name']),
      ),
      body: Center(
        child: Container(
          color: const Color.fromARGB(255, 245, 243, 230),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (_imageUrl.isNotEmpty)
                    Image.network(
                      _imageUrl,
                      height: 200,
                      width: 200,
                      fit: BoxFit.cover,
                    )
                  else
                    Text(
                      'Imagen no disponible',
                      style: TextStyle(fontSize: 16, color: Colors.red),
                    ),
                  SizedBox(height: 16),
                  Text(
                    'Nombre: ${widget.exercise['name']}',
                    style: TextStyle(fontSize: 24),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Tipo: ${widget.exercise['type']}',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Dificultad: ${widget.exercise['difficulty']}',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Instrucciones:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Text(
                    _instructions,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _startTimer,
                    child: Text('Empezar Ejercicio'),
                  ),
                  SizedBox(height: 32),
                  Text(
                    'Tiempo restante: $minutes:$seconds',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: _progress,
                    backgroundColor: Colors.grey[300],
                    color: Colors.blue,
                    minHeight: 10,
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _canComplete ? () {
                      widget.onExerciseCompleted();
                      Navigator.pop(context);
                    } : null,
                    child: Text('Marcar como completado'),
                  ),
                  SizedBox(height: 16),
                  if (_exerciseCompleted)
                    Text(
                      '¡Ejercicio completado!',
                      style: TextStyle(fontSize: 24, color: Colors.green),
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
// Página para mostrar los detalles de la rutina creada
