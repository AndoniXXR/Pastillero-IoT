import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

class PageOne extends StatefulWidget {
  @override
  _PageOneState createState() => _PageOneState();
}

class _PageOneState extends State<PageOne> {
  bool allDaysOn = false; // Estado actual de los días (si están todos en 1 o 0)
  final DatabaseReference _databaseReference =
      FirebaseDatabase.instance.ref(); // Referencia de la base de datos

  // Esta función alterna todos los días en la base de datos
  void _toggleAllDays() async {
    setState(() {
      allDaysOn = !allDaysOn; // Alterna entre true (1) y false (0)
    });

    // Crear un mapa con el nuevo estado de los días
    Map<String, int> updatedDays = {
      'Compartimiento1': allDaysOn ? 190 : 0,
      'Compartimiento2': allDaysOn ? 190 : 0,
      'Compartimiento3': allDaysOn ? 190 : 0,
      'Compartimiento4': allDaysOn ? 190 : 0,
      'Compartimiento5': allDaysOn ? 190 : 0,
      'Compartimiento6': allDaysOn ? 190 : 0,
      'Compartimiento7': allDaysOn ? 190 : 0,
    };

    try {
      // Actualizar todos los días en Firebase
      await _databaseReference.child('test/days').update(updatedDays);
      print('Llenar el Pastillero : ${allDaysOn ? 190 : 0}');
    } catch (e) {
      print('Error al actualizar la base de datos: $e');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Llenar Pastillero",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 150, 200, 0),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _toggleAllDays,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                allDaysOn ? Colors.green : Colors.red, // Cambia el color
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
            textStyle: TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Bordes redondeados
            ),
          ),
          child: Text(
            allDaysOn
                ? 'Cerrar los Compartimientos'
                : 'Abrir los Compartimientos',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}
