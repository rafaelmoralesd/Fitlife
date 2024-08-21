import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:myapp/DetalleRutinaPage.dart'; // Asegúrate de tener esta importación

class RutinaPage extends StatefulWidget {
  @override
  _RutinaPageState createState() => _RutinaPageState();
}

class _RutinaPageState extends State<RutinaPage> {
  List<Map<String, dynamic>> _createdRoutines = [];

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    final prefs = await SharedPreferences.getInstance();
    final routines = prefs.getStringList('routines') ?? [];

    setState(() {
      _createdRoutines = routines
          .map((r) => json.decode(r) as Map<String, dynamic>)
          .toList();
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
            // Implementa la lógica para actualizar los ejercicios aquí
          },
        ),
      ),
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutinas Creadas'),
        backgroundColor: Color.fromARGB(255, 184, 192, 241),
        automaticallyImplyLeading: true, // Mostrar botón de regreso
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _createdRoutines.isEmpty
              ? Text(
                  'No hay rutinas creadas.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.red),
                )
              : ListView.builder(

                  itemCount: _createdRoutines.length,
                  itemBuilder: (context, index) {
                    final routine = _createdRoutines[index];
                    return ListTile(
// Suggested code may be subject to a license. Learn more: ~LicenseLog:1095731649.
                      leading: Icon(Icons.folder),
                      title: Text(routine['name']),
                      subtitle: Text('${routine['exercises'].length} ejercicios'),
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
                  },
                ),
        ),
      ),
    );
  }
}
