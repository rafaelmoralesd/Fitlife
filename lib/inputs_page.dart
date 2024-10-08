import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/custom_input.dart';

import 'package:myapp/principal_page.dart';
import 'package:social_auth_buttons/social_auth_buttons.dart';

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
                      if (value == 'rmoralesd@unah.hn' &&
                          value == 'fj.murillo@unah.hn') {
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
                      if (value == '20202001873' && value == '20222001186') {
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
                      MaterialPageRoute(
                          builder: (context) => const PrincipalPage()),
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
                const SizedBox(height: 19, child: Text('ó ')),
                SizedBox(
                    width: 250,
                    height: 40,
                    child: GoogleAuthButton(onPressed:() async{
                     await signInWithGoogle();
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrincipalPage()),
                    );
                    },))
              ],
            ),
          ),
        ),
      ),
    );
  }
Future<UserCredential> signInWithGoogle() async {
  // Inicia el flujo de autenticación de Google
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Si el usuario cancela el flujo de inicio de sesión, googleUser será null
  if (googleUser == null) {
    throw Exception('Google sign-in was cancelled');
  }

  // Obtén los detalles de autenticación del pedido de inicio de sesión
  final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

  // Crea una credencial para Firebase con el token de Google
  final AuthCredential credential = GoogleAuthProvider.credential(
    accessToken: googleAuth.accessToken,
    idToken: googleAuth.idToken,
  );

  // Inicia sesión en Firebase con la credencial de Google
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
}