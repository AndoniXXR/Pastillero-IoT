import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:app_iot/screens/auth_screen.dart'; // Pantalla de autenticación
import 'page_one.dart'; // Importamos PageOne
import 'page_two.dart'; // Importamos PageTwo
// Importamos la notificación

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Medi Control',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 150, 200, 0),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Botón para ir a la Página 1
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PageOne()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Color de fondo
                foregroundColor: Colors.white, // Color del texto
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Llenar Pastillero',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 20), // Espacio entre los botones
            // Botón para ir a la Página 2
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => PageTwo()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Color de fondo
                foregroundColor: Colors.white, // Color del texto
                padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              child: Text(
                'Alarmas',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 20), // Espacio entre los botones
          ],
        ),
      ),
    );
  }
}
