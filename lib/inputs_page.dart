import 'package:flutter/material.dart';
import 'package:myapp/custom_input.dart';
import 'package:myapp/main.dart';
import 'package:myapp/principal_page.dart';

class InputsPage extends StatelessWidget {
  InputsPage({super.key});

  final TextEditingController correoController = TextEditingController();
  final TextEditingController contraseniaController = TextEditingController();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text(
          'Fitlife',
          textAlign: TextAlign.center,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              children: [
                const SizedBox(height: 16),
                Center(
                  child: Container(
                    color: Colors.amber,
                    height: 250,
                    child: Image.asset(
                      'assets/imagen1.jpeg',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: CuntomInput(
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
                ),
                const SizedBox(height: 10),
                SizedBox(
                  width: 250,
                  height: 50,
                  child: CuntomInput(
                    controller: contraseniaController,
                    label: 'Contraseña',
                    icon: Icons.lock,
                    obscureText: true,
                    maxLength: 30,
                    keyboardType: TextInputType.visiblePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'La contraseña es obligatoria';
                      }
                      if (value != '20202001873') {
                        return 'La contraseña no es válida';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
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
                    'Iniciar sesión',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                SizedBox(
                  height: 30,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(0, 235, 230, 230),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushNamed('registrar');

                      // Acción
                    },
                    child: const Text(
                      'Registrarse',
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                ),
                 
                const SizedBox(
                height: 20,
                child: Text('ó ')),
               SizedBox(
                
                width: 250,
                  height: 30,
                  child: ElevatedButton(
                    
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(193, 219, 54, 54),
                    ),
                    onPressed: () async {
                      await signInWithGoogle();
               
                      // Acción
                    },
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      
                      children: [
                        Icon(
                          Icons.email,
                          color: Color.fromARGB(255, 252, 247, 247),
             
                        ),
                        //SizedBox(width: 10)
                        Text(
  
                          'Iniciar con Google',
                          style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 253, 253)),
                        ),
                      ],
                    ),
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
