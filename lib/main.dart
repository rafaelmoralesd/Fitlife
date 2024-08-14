import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:myapp/firebase_options.dart';
import 'package:myapp/inputs_page.dart';
import 'package:myapp/principal_page.dart';
import 'package:myapp/registrar_page.dart';

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FitLife',
      // home: HomePage(),
      initialRoute: 'inicio', //esta es la ruta principal
      routes: {
        'registrar': (context) => RegistrarPage(),
        'inicio': (context) => InputsPage(),
        'principal': (context) => const PrincipalPage(),
      },
      onGenerateRoute: (RouteSettings settings) {
        return MaterialPageRoute(
          builder: (context) => PageNotFound(ruta: settings.name),
        );
      },
    );
  }
}

class HomePage {
  const HomePage();
}

class PageNotFound extends StatelessWidget {
  const PageNotFound({
    super.key,
    this.ruta = 'No-found',
  });

  final String? ruta;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('La ruta "$ruta" no existe')));
  }
}

Future<UserCredential> signInWithGoogle() async {
  // Trigger the authentication flow
  final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  // Obtain the auth details from the request
  final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

  // Create a new credential
  final credential = GoogleAuthProvider.credential(
    accessToken: googleAuth?.accessToken,
    idToken: googleAuth?.idToken,
  );

  // Once signed in, return the UserCredential
  return await FirebaseAuth.instance.signInWithCredential(credential);
}