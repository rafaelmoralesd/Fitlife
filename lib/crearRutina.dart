import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:myapp/CustomRoutinePage.dart';
import 'package:myapp/DetalleRutinaPage.dart';
import 'package:myapp/RutinaPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Crearrutina extends StatefulWidget {
  @override
  _RutinaCreationPageState createState() => _RutinaCreationPageState();
}

class _RutinaCreationPageState extends State<Crearrutina> {
  final _ageController = TextEditingController();
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  List<Map<String, dynamic>> _createdRoutines = [];
  String _apiResponse = '';

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
    _showErrorDialog('La edad, peso y estatura son obligatorios para obtener una rutina recomendada.');
    return;
  }


    final response = await http.get(Uri.parse(
        'https://example.com/api/routine?age=$age&weight=$weight&height=$height'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _apiResponse = data['routine'];
      });
    } else {
      setState(() {
        _apiResponse = 'Error al obtener la rutina.';
      });
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
      _createdRoutines = routines
          .map((r) => json.decode(r) as Map<String, dynamic>)
          .toList();
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
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Crear y Seguir Rutinas'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
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
                  child: const Text('Obener una rutina recomendada'),
                ),
                const SizedBox(height: 16),
                const Text('Rutina Recomendada:'),
                Text(_apiResponse, textAlign: TextAlign.center),
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
                 const Text('Presione  para iniciar cualquier rutina :', textAlign: TextAlign.center),
                const SizedBox(height: 8),
                if (_createdRoutines.isEmpty)
                  const Text('No hay rutinas creadas.',textAlign: TextAlign.center,style: TextStyle( color: Colors.red, ),)
                else
                Column(
                  children: _createdRoutines.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map<String, dynamic> routine = entry.value;
                    return ListTile(
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
                  }).toList(),
                ),
              
              ],
            ),
          ),
        ),
      ),
    );
  }
}