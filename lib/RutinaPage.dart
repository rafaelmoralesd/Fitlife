import 'package:flutter/material.dart';
import 'package:myapp/DetalleRutinaPage.dart';

class RutinaPage extends StatelessWidget {
  final List<Map<String, dynamic>> createdRoutines;

  const RutinaPage({super.key, required this.createdRoutines});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rutina de Ejercicios'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView.builder(
        itemCount: createdRoutines.length,
        itemBuilder: (context, index) {
          final routine = createdRoutines[index];
          return ListTile(
            title: Text(routine['name']),
            subtitle: Text('${routine['exercises'].length} ejercicios'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetalleRutinaPage(
                    exercises: routine['exercises'],
                    routineName: routine['name'],
                  ),
                ),
              );
            },
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                _confirmDeleteRoutine(context, index);
              },
            ),
          );
        },
      ),
    );
  }

  void _confirmDeleteRoutine(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmar Eliminación'),
          content: Text('¿Estás seguro de que deseas eliminar esta rutina?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Eliminar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
