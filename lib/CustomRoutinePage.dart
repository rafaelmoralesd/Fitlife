import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomRoutinePage extends StatefulWidget {
  final Function(Map<String, dynamic>) onSaveRoutine;

  CustomRoutinePage({required this.onSaveRoutine});

  @override
  _CustomRoutinePageState createState() => _CustomRoutinePageState();
}

class _CustomRoutinePageState extends State<CustomRoutinePage> {
  final _exerciseNameController = TextEditingController();
  final _durationController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _routineNameController = TextEditingController();

  List<Map<String, String>> _exercises = [];

  void _addExercise() {
    final name = _exerciseNameController.text;
    final duration = _durationController.text;
    final description = _descriptionController.text;

    if (name.isNotEmpty && duration.isNotEmpty && description.isNotEmpty) {
      setState(() {
        _exercises.add({
          'name': name,
          'duration': duration,
          'description': description,
        });
        _exerciseNameController.clear();
        _durationController.clear();
        _descriptionController.clear();
      });
    } else {
      _showErrorDialog('El nombre del ejercicio, la duración y la descripción son obligatorios.');
    }
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
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _saveRoutine() {
    final routineName = _routineNameController.text;
    
  
    if (routineName.isEmpty) {
      _showErrorDialog('El nombre de la rutina es obligatorio.');
      return;
    }

    if (_exercises.length < 2) {
      _showErrorDialog('Debes agregar al menos dos ejercicios para guardar la rutina.');
      return;
    }
    

    widget.onSaveRoutine({
      'name': routineName,
      'exercises': _exercises,
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Rutina Guardada'),
        content: Text('Se han guardado ${_exercises.length} ejercicios a tu rutina.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
                 Navigator.pop(context);
            
            },
          ),
        ],
      ),
    );
  }

  void _removeExercise(int index) {
    setState(() {
      _exercises.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text('Crear Rutina Personalizada'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: _exercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _exercises[index];
                    return ListTile(
                      leading: Icon(Icons.fitness_center), // Ícono de fitness
                      title: Text(exercise['name']!),
                      subtitle: Text('${exercise['duration']} minutos\n${exercise['description']}'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _removeExercise(index),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _exerciseNameController,
                  decoration: InputDecoration(labelText: 'Nombre del Ejercicio'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _durationController,
                   inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly, // Permite solo números
                ],
                  decoration: InputDecoration(labelText: 'Duración (minutos)'),
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _descriptionController,
                  decoration: InputDecoration(labelText: 'Descripción'),
                  textAlign: TextAlign.center,
                  maxLines: 4,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _addExercise,
                  child: Text('Agregar Ejercicio'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _routineNameController,
                  decoration: InputDecoration(labelText: 'Nombre de la Rutina'),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _saveRoutine,
                  child: Text('Guardar Rutina'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
