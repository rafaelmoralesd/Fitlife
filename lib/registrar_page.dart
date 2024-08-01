import 'package:flutter/material.dart';
import 'package:myapp/custom_input.dart';

class RegistrarPage extends StatelessWidget {
 RegistrarPage({super.key});

  final TextEditingController nombreController = TextEditingController();
  final TextEditingController correoController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
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
                    controller: correoController,
                    label: 'Correo',
                    icon: Icons.email,
                    maxLength: 50,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El correo es obligatorio';
                      }

                      if (!value.contains('@')) {
                        return 'El correo no contiene un @';
                      }
                       if (!value.endsWith('unah.hn')) {
                        return 'El correo tiene que terminar en unah.hn';
                      }
                      if (value.allMatches('@').length != 1) {
                        return 'El correo tiene mas de una @ ';
                      }
                      


                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  CuntomInput(
                    controller: telefonoController,
                    label: 'Telefono',
                    maxLength: 8,
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'El numero es obligatorio';
                      }

                      if (int.tryParse(value) == null 
                          ) {
                        return 'El teléfono no es válido';
                      }
                       if (!value.startsWith('3')&&!value.startsWith('9') ) {
                        return 'El telefono debe iniciar con un 3 o 9';
                      }
                      if (value.length < 8) {
                        return 'El numero no contiene 8 digitos';
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
                        if(!_mayuscula(value)){
                        return 'La contraseña necesita al menos una letra mayúscula';
                      }
                      if(!_caracterEspecial(value)){
                        return 'La contraseña necesita al menos un caracter especial';
                      }


                      return null;
                    },
                   
                  ),
                  const SizedBox(height: 16),
                  CuntomInput(
                    controller: contrasenia2Controller,
                    label: 'Confirme Contraseña',
                    icon: Icons.lock,
                    obscureText: true,
                    maxLength: 30,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es obligatorio';
                      }
                      if (value != contraseniaController.text) {
                        return 'Las contraseñas no coinciden';
                      } 
                  
                      return null;
                    },
                  ),
                  ElevatedButton(
                  onPressed: () {
                     if (!formKey.currentState!.validate()) {
              return;
            }

            final data = {
              'nombre': nombreController.text,
              'correo': correoController.text,
              'telefono': telefonoController.text,
             
              'contrasenia': contraseniaController.text,
            };

            print(data);
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