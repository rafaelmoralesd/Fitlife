import 'package:flutter/material.dart';
import 'dart:async'; // Importar para usar Timer
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseDetailPage extends StatefulWidget {
  final String exerciseName;
  final String duration;
  final String description;
  final Function(String) onComplete; // Callback para marcar el ejercicio como completado

  const ExerciseDetailPage({
    Key? key,
    required this.exerciseName,
    required this.duration,
    required this.description,
    required this.onComplete, // Recibir el callback
  }) : super(key: key);

  @override
  _ExerciseDetailPageState createState() => _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends State<ExerciseDetailPage> {
  String _imageUrl = '';
  Timer? _timer;
  int _remainingTime = 0; // Tiempo restante en segundos
  bool _isRunning = false; // Estado del cronómetro
  bool _isCompleted = false; // Estado del ejercicio

  @override
  void initState() {
    super.initState();
    _fetchExerciseImage();
    _remainingTime = int.parse(widget.duration) * 60; // Convertir minutos a segundos
  }

  Future<void> _fetchExerciseImage() async {
    final response = await http.get(Uri.parse('https://example.com/api/exercise_image?name=${widget.exerciseName}'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _imageUrl = data['image_url'];
      });
    } else {
      setState(() {
        _imageUrl = 'https://via.placeholder.com/150'; // Imagen por defecto en caso de error
      });
    }
  }

  void _startExercise() {
    if (_isRunning) return; // Evitar múltiples inicios
    setState(() {
      _isRunning = true;
      _isCompleted = false;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_remainingTime > 0) {
          setState(() {
            _remainingTime--;
          });
        } else {
          timer.cancel();
          setState(() {
            _isRunning = false;
            _isCompleted = true;
          });
          widget.onComplete(widget.exerciseName); // Notificar que el ejercicio está completo
        }
      });
    });
  }

  void _stopExercise() {
    _timer?.cancel();
    setState(() {
      _isRunning = false;
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancelar el cronómetro si se cierra la página
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_remainingTime ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingTime % 60).toString().padLeft(2, '0');
    final progress = (_remainingTime / (int.parse(widget.duration) * 60)).clamp(0.0, 1.0);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Detalles del Ejercicio'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  opacity: 0.4,
                  image: AssetImage('assets/imagen 4.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  widget.exerciseName,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Duración: ${widget.duration} minutos',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Descripción:',
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.description,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                _imageUrl.isNotEmpty
                    ? Image.network(
                        _imageUrl,
                        height: 150, // Puedes ajustar la altura según tus necesidades
                        width: 150,  // Puedes ajustar el ancho según tus necesidades
                      )
                    : CircularProgressIndicator(),
                const SizedBox(height: 32),
                LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  color: Colors.blue,
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 16),
                Text(
                  'Cronómetro: $minutes:$seconds',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _startExercise,
                  child: Text(_isRunning ? 'Ejercicio en Progreso' : 'Empezar Ejercicio'),
                ),
                if (_isRunning)
                  ElevatedButton(
                    onPressed: _stopExercise,
                    child: Text('Detener Ejercicio'),
                  ),
                if (_isCompleted)
                  Text(
                    'Ejercicio Completado',
                    style: TextStyle(color: Colors.green, fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
