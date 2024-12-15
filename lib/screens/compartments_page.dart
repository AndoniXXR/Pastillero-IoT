import 'package:flutter/material.dart';
import 'package:alarm/model/alarm_settings.dart';

class CompartmentsPage extends StatelessWidget {
  final int dayIndex;
  final List<AlarmSettings?> alarms;
  final Function(int, bool) toggleAlarm;
  final Function(int) setAlarmForDay;

  CompartmentsPage({
    required this.dayIndex,
    required this.alarms,
    required this.toggleAlarm,
    required this.setAlarmForDay,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurar ${_getDayName(dayIndex)}'),
      ),
      body: ListView.builder(
        itemCount: 7, // Siempre mostrar 7 compartimientos
        itemBuilder: (context, index) {
          final alarm = index < alarms.length ? alarms[index] : null;
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                alarm != null
                    ? "${alarm.dateTime.hour.toString().padLeft(2, '0')}:${alarm.dateTime.minute.toString().padLeft(2, '0')}"
                    : "Configura una alarma",
                style: const TextStyle(fontSize: 18),
              ),
              subtitle: alarm != null
                  ? Text('Alarma configurada')
                  : Text('Sin alarma'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit,
                        color: Color.fromARGB(255, 150, 200, 0)),
                    onPressed: () => setAlarmForDay(index),
                  ),
                  Switch(
                    value: alarm != null,
                    onChanged: (value) => toggleAlarm(index, value),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _getDayName(int index) {
    List<String> days = [
      'Lunes',
      'Martes',
      'Miércoles',
      'Jueves',
      'Viernes',
      'Sábado',
      'Domingo',
    ];
    return days[index];
  }
}