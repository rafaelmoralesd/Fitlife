import 'package:flutter/material.dart';
import 'package:myapp/custom_input.dart';
import 'package:myapp/principal_page.dart';

class RegistrarPage extends StatelessWidget {
  RegistrarPage({super.key});

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController edadController = TextEditingController();
  final TextEditingController estaturaController = TextEditingController();
  final TextEditingController pesoController = TextEditingController();
  final TextEditingController contraseniaController = TextEditingController();
  final TextEditingController contrasenia2Controller = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CuntomInput(
                  label: 'Nombre',
                  maxLength: 10,
                  controller: nombreController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El nombre es obligatorio';
                    }
                    if (value.length < 3) {
                      return 'El nombre tiene un minimo de 3 letras';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CuntomInput(
                  controller: edadController,
                  label: 'Edad',
                  maxLength: 50,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La edad es obligatorio';
                    }
                    if (int.tryParse(value) == null) {
                      return 'La edad no es válida';
                    }
                    if (int.parse(value) < 18) {
                      return 'La edad debe ser mayor a 18';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CuntomInput(
                  controller: estaturaController,
                  label: 'Estatura',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'La estatura es obligatorio';
                    }

                    if (int.tryParse(value) == null) {
                      return 'La estatura no es válido';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CuntomInput(
                  controller: pesoController,
                  label: 'Peso',
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'El peso es obligatorio';
                    }

                    if (int.tryParse(value) == null) {
                      return 'El peso no es válido';
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
                    if (value.length < 8) {
                      return 'La contraseña tiene un minimo de 8 letras';
                    }
                    if (!_mayuscula(value)) {
                      return 'La contraseña necesita al menos una letra mayúscula';
                    }
                    if (!_caracterEspecial(value)) {
                      return 'La contraseña necesita al menos un caracter especial';
                    }

                    return null;
                  },
                ),
                const SizedBox(height: 16),
                CuntomInput(
                  controller: contrasenia2Controller,
                  label: 'Confirme Contraseña',
                  obscureText: true,
                  keyboardType: TextInputType.visiblePassword,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Confirmar la contraseña es obligatorio';
                    }
                    if (value != contraseniaController.text) {
                      return 'Las contraseñas no coinciden';
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

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => PrincipalPage()),
                    );
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

bool _mayuscula(String value) {
  // Expresión regular para verificar que haya al menos una letra mayúscula
  final RegExp upperCaseRegex = RegExp(r'[A-Z]');
  return upperCaseRegex.hasMatch(value);
}

bool _caracterEspecial(String value) {
  // Expresión regular para verificar que haya al menos un carácter especial
  final RegExp specialCharRegex = RegExp(r'[!@#$%^&*(),.?":{}|<>]');
  return specialCharRegex.hasMatch(value);
}
