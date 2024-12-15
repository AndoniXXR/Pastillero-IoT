import 'dart:async';
import 'dart:io';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_iot/AlarmNotification.dart';

class PageTwo extends StatefulWidget {
  @override
  _PageTwoState createState() => _PageTwoState();
}

class _PageTwoState extends State<PageTwo> {
  // Lista de AlarmSettings?, donde algunas alarmas pueden ser nulas
  List<AlarmSettings?> compartimientoAlarms = List.filled(7, null);
  // Lista que maneja si cada alarma está activa o no
  List<bool> alarmsActive = List.filled(7, false);

  static StreamSubscription<AlarmSettings>? subscription;

  @override
  void initState() {
    super.initState();
    checkAndroidNotificationPermission();
    checkAndroidScheduleExactAlarmPermission();
    loadAlarms();
    subscription ??= Alarm.ringStream.stream.listen(navigateToRingScreen);
  }

  void loadAlarms() {
    setState(() {
      compartimientoAlarms = List.generate(7, (index) {
        var alarms = Alarm.getAlarms();
        return alarms.firstWhere(
          (alarm) => alarm.id == index + 1,
          orElse: () => AlarmSettings(
            id: index + 1,
            dateTime: DateTime.now(), // Valor por defecto
            assetAudioPath: 'assets/alarm.mp3',
            loopAudio: true,
            vibrate: true,
            volume: 0.8,
            fadeDuration: 3.0,
            notificationTitle: 'Alarma para ${_getCompartimientoName(index)}',
            notificationBody:
                'Es la hora de tu alarma del ${_getCompartimientoName(index)}',
            enableNotificationOnKill: Platform.isIOS,
          ),
        );
      });
    });
  }

  Future<void> checkAndroidNotificationPermission() async {
    final status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> checkAndroidScheduleExactAlarmPermission() async {
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isDenied) {
      await Permission.scheduleExactAlarm.request();
    }
  }

  Future<void> navigateToRingScreen(AlarmSettings alarmSettings) async {
    await Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (context) =>
            AlarmNotificationScreen(alarmSettings: alarmSettings),
      ),
    );
    _rescheduleAlarmForNextWeek(alarmSettings);
    loadAlarms();
  }

  void _rescheduleAlarmForNextWeek(AlarmSettings alarmSettings) {
    final DateTime nextAlarmDateTime =
        alarmSettings.dateTime.add(const Duration(days: 7));

    final updatedAlarmSettings = alarmSettings.copyWith(
      dateTime: nextAlarmDateTime,
    );

    Alarm.set(alarmSettings: updatedAlarmSettings);
  }

  Future<TimeOfDay?> _selectTime(BuildContext context) async {
    return await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
  }

  Future<void> _setAlarmForCompartimiento(int compartimientoIndex) async {
    TimeOfDay? pickedTime = await _selectTime(context);

    if (pickedTime != null) {
      DateTime now = DateTime.now();
      DateTime alarmDateTime = DateTime(
          now.year, now.month, now.day, pickedTime.hour, pickedTime.minute);

      final alarmSettings = AlarmSettings(
        id: compartimientoIndex + 1,
        dateTime: alarmDateTime,
        assetAudioPath: 'assets/alarm.mp3',
        loopAudio: true,
        vibrate: true,
        volume: 0.8,
        fadeDuration: 3.0,
        notificationTitle:
            'Alarma para ${_getCompartimientoName(compartimientoIndex)}',
        notificationBody:
            'Es la hora de tu alarma del ${_getCompartimientoName(compartimientoIndex)}',
        enableNotificationOnKill: Platform.isIOS,
      );

      await Alarm.set(alarmSettings: alarmSettings);
      setState(() {
        compartimientoAlarms[compartimientoIndex] = alarmSettings;
        alarmsActive[compartimientoIndex] = true;
      });
    }
  }

  void _toggleAlarm(int index, bool isActive) {
    final alarm = compartimientoAlarms[index];
    if (alarm != null) {
      final now = DateTime.now();

      // Si la hora ya pasó, reprogramamos la alarma para el próximo día
      if (isActive && alarm.dateTime.isBefore(now)) {
        final nextAlarmDateTime = alarm.dateTime.add(const Duration(days: 1));
        final updatedAlarmSettings = alarm.copyWith(
          dateTime: nextAlarmDateTime,
        );

        // Actualizamos la alarma con la nueva hora
        Alarm.set(alarmSettings: updatedAlarmSettings);
        setState(() {
          compartimientoAlarms[index] = updatedAlarmSettings;
          alarmsActive[index] = true;
        });
      } else if (isActive) {
        // Activar la alarma si la hora no ha pasado
        Alarm.set(alarmSettings: alarm);
        setState(() {
          alarmsActive[index] = true;
        });
      } else {
        // Desactivar la alarma
        Alarm.stop(alarm.id);
        setState(() {
          alarmsActive[index] = false;
        });
      }
    }
  }

  String _getCompartimientoName(int index) {
    List<String> compartimientos = [
      'Compartimiento1',
      'Compartimiento2',
      'Compartimiento3',
      'Compartimiento4',
      'Compartimiento5',
      'Compartimiento6',
      'Compartimiento7',
    ];
    return compartimientos[index];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Alarmas',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 150, 200, 202),
      ),
      body: ListView.builder(
        itemCount: 7,
        itemBuilder: (context, index) {
          final alarm = compartimientoAlarms[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: ListTile(
              title: Text(
                alarm != null
                    ? "${_getCompartimientoName(index)}: ${alarm.dateTime.hour.toString().padLeft(2, '0')}:${alarm.dateTime.minute.toString().padLeft(2, '0')}"
                    : "Configura la alarma para ${_getCompartimientoName(index)}",
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
                    onPressed: () => _setAlarmForCompartimiento(index),
                  ),
                  Switch(
                    value: alarmsActive[index],
                    onChanged: (value) => _toggleAlarm(index, value),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
