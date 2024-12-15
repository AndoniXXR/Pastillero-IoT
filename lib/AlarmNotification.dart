import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:firebase_database/firebase_database.dart'; // Importamos Firebase
import 'package:flutter/material.dart';

class AlarmNotificationScreen extends StatefulWidget {
  final AlarmSettings alarmSettings;
  AlarmNotificationScreen({super.key, required this.alarmSettings});

  @override
  State<AlarmNotificationScreen> createState() =>
      _AlarmNotificationScreenState();
}

class _AlarmNotificationScreenState extends State<AlarmNotificationScreen> {
  final DatabaseReference _databaseReference = FirebaseDatabase.instance.ref();

  // Función para enviar datos a Firebase cuando la alarma suene
  Future<void> _sendDataToFirebase() async {
    try {
      // Obtener el nombre del compartimiento con base en el ID de la alarma
      String compartimientoName =
          _getCompartimientoName(widget.alarmSettings.id);

      // Enviar el valor 180 al compartimiento correspondiente en el día jueves
      await _databaseReference.child('jueves/$compartimientoName').set(180);
      print('Valor 180 enviado para $compartimientoName');
    } catch (e) {
      print('Error al enviar datos a Firebase: $e');
    }
  }

  // Función que convierte el ID de la alarma al nombre del compartimiento
  String _getCompartimientoName(int alarmId) {
    List<String> compartimientos = [
      'Compartimiento1',
      'Compartimiento2',
      'Compartimiento3',
      'Compartimiento4',
      'Compartimiento5',
      'Compartimiento6',
      'Compartimiento7',
    ];
    return compartimientos[
        alarmId - 1]; // Ajustamos el ID para que coincida con el índice
  }

  @override
  void initState() {
    super.initState();
    _sendDataToFirebase(); // Enviamos los datos cuando la alarma suena
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Alarma Activa',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24.0,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 150, 200, 0),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "La alarma está sonando...",
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
                color: Colors.redAccent,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              widget.alarmSettings.notificationTitle ?? "Alarma",
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              widget.alarmSettings.notificationBody ??
                  "Es la hora de la alarma",
              style: TextStyle(fontSize: 18.0),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Posponer alarma
                    final now = DateTime.now();
                    Alarm.set(
                      alarmSettings: widget.alarmSettings.copyWith(
                        dateTime: DateTime(
                          now.year,
                          now.month,
                          now.day,
                          now.hour,
                          now.minute,
                        ).add(const Duration(minutes: 1)),
                      ),
                    ).then((_) => Navigator.pop(context));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange, // Color de fondo
                    foregroundColor: Colors.white, // Color del texto
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text("Posponer"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    // Detener la alarma
                    Alarm.stop(widget.alarmSettings.id)
                        .then((_) => Navigator.pop(context));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red, // Color de fondo
                    foregroundColor: Colors.white, // Color del texto
                    padding:
                        EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text("Detener"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
