import 'package:flutter/material.dart';
import 'package:myapp/custom_input.dart';

class InputsPage extends StatelessWidget {
  InputsPage({super.key});

  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraseniaController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(' Inicio de sesión'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                CuntomInput(
                  controller: correoController,
                  label: 'Correo',
                  icon: Icons.email,
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El correo es obligatorio';
                    }
                    if (!value.contains('@')) {
                      return 'El correo no es válido';
                    }
                    if (value != 'rmoralesd@unah.hn') {
                      return 'El correo no es válido';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CuntomInput(
                  controller: contraseniaController,
                  label: 'Contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                  maxLength: 30,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La contraseña es obligatorio';
                    }
                    if(value != '20202001873'){
                      return 'La contraseña no es válida';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (!formKey.currentState!.validate()) {
                      return;
                    }
                    Navigator.of(context).pushNamed('inicio');
                    final data = {
                      'correo': correoController.text,
                      'contrasenia': contraseniaController.text,
                    };

                    print(data);
                    // Acción
                  },
                  child: const Text(
                    ' iniciar sesión',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed('registrar');
                    // Acción
                  },
                  child: const Text(
                    ' registrarse',
                    style: TextStyle(fontSize: 20),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}