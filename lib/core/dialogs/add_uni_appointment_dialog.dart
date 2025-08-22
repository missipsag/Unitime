import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitime/core/constants/uni_appointment_types.dart';
import 'package:unitime/service/appointment_service.dart';

class AddUniAppointmentDialog extends StatefulWidget {
  const AddUniAppointmentDialog({super.key});

  @override
  State<AddUniAppointmentDialog> createState() =>
      _AddUniAppointmentDialogState();
}

class _AddUniAppointmentDialogState extends State<AddUniAppointmentDialog> {
  final List<String> _types = ['TD', 'TP', 'Cours', 'Evènement spécial'];
  String? _type;
  UniAppointmentTypes? _selectedType;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedStartDate = DateTime.now();
  DateTime? _selectedEndDate = DateTime.now();
  TimeOfDay? _selectedStartTime = TimeOfDay.now();
  TimeOfDay? _selectedEndTime = TimeOfDay.now();
  DateFormat dateFormat = DateFormat("EEE, dd MMM yyyy");
  DateFormat hourFormat = DateFormat("HH:mm");
  int? roomNbr;

  static final Map<String, UniAppointmentTypes> stringToUniApp = {
    'TD': UniAppointmentTypes.td,
    'TP': UniAppointmentTypes.tp,
    'Cours': UniAppointmentTypes.course,
    'Evènement spécial': UniAppointmentTypes.specialEvent,
  };
  static final List<String> _recurrence = ["Once", "Daily", "Weekly"];
  String? _chosedRec;
  static final Map<String, String> _appointmentRecurrence = {
    "Once": "",
    "Daily": "FREQ=DAILY",
    "Weekly": "FREQ=WEEKLY;BYDAY=",
  };

  String _byDayRecurrence(List<String> days) {
    String byday = "";

    for (var i = 0; i < days.length; i++) {
      byday = byday + days[i]!.toUpperCase().substring(0, 2) + ',';
    }
    byday = byday.substring(0, byday.length - 1);
    return byday;
  }

  List<String> _daysOfWeek = [
    "Sunday",
    "Monday",
    "Thusday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
  ];

  List<String> _selectedDays = [];

  List<int> generateRoomNbrs(int len) {
    List<int> possibleRoomNbrs = <int>[];
    for (var i = 1; i <= len; i++) {
      possibleRoomNbrs.add(i);
    }
    return possibleRoomNbrs;
  }

  late final TextEditingController _subjectController;
  late final AppointmentService _appointmentService;

  @override
  void initState() {
    _subjectController = TextEditingController();
    _appointmentService = AppointmentService();
    super.initState();
  }

  @override
  void dispose() {
    _subjectController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),

      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          spacing: 15,

          children: [
            Container(
              alignment: Alignment.topRight,

              padding: const EdgeInsets.symmetric(horizontal: 12),

              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purpleAccent,
                  textStyle: TextStyle(color: Colors.white),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // adjust radius
                  ),
                ),

                onPressed: () async {
                  if (_selectedStartTime!.isBefore(
                        TimeOfDay(hour: 7, minute: 0),
                      ) ||
                      _selectedStartTime!.isAfter(
                        TimeOfDay(hour: 17, minute: 00),
                      )) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("The start time is not valid")),
                    );
                  } else if (_selectedEndTime!.isBefore(
                        TimeOfDay(hour: 7, minute: 0),
                      ) ||
                      _selectedEndTime!.isAfter(
                        TimeOfDay(hour: 17, minute: 00),
                      )) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("The end time is not valid")),
                    );
                  } else if (_selectedStartTime!.isAfter(_selectedEndTime!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("The start time is not valid")),
                    );
                  } else if (_selectedEndTime!.isBefore(_selectedStartTime!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("The end time is not valid")),
                    );
                  } else if (_chosedRec == "Weekly" && _selectedDays.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Please select recurrent days for the appointment.",
                        ),
                      ),
                    );
                  } else if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    _selectedType = stringToUniApp[_type];
                    final String? rec;
                    switch (_chosedRec) {
                      case "Weekly":
                        rec =
                            _appointmentRecurrence[_chosedRec]! +
                            _byDayRecurrence(_selectedDays);
                        break;
                      case "Daily":
                        rec = _appointmentRecurrence[_chosedRec];
                        break;
                      default:
                        rec = _appointmentRecurrence[_chosedRec];
                        break;
                    }

                    final newAppointment = await _appointmentService
                        .createAppointment(
                          start: DateTime(
                            _selectedStartDate!.year,
                            _selectedStartDate!.month,
                            _selectedStartDate!.day,
                            _selectedStartTime!.hour,
                            _selectedStartTime!.minute,
                          ),
                          end: DateTime(
                            _selectedEndDate!.year,
                            _selectedEndDate!.month,
                            _selectedEndDate!.day,
                            _selectedEndTime!.hour,
                            _selectedEndTime!.minute,
                          ),
                          uniAppointmentSubject: _subjectController.text,
                          roomNum: roomNbr!,
                          type: _selectedType!,
                          recurrence: rec!,
                        );

                    Navigator.of(context).pop(newAppointment);
                  }
                },
                child: const Text("Add"),
              ),
            ),

            Container(
              margin: const EdgeInsets.only(bottom: 2),
              padding: const EdgeInsets.symmetric(horizontal: 12),

              child: DropdownButtonFormField<String>(
                value: _type,

                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Category"),
                  prefixIcon: Icon(Icons.school_sharp),
                ),
                isExpanded: true,
                items: _types.map((String type) {
                  return DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _type = value;
                  });
                },
                validator: (value) {
                  return value == null
                      ? "Please select an appointement type."
                      : null;
                },
              ),
            ),

            Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),

              child: TextFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Subject"),
                  hintText: "Enter a subject",
                  prefixIcon: Icon(Icons.menu_book_sharp),
                ),
                controller: _subjectController,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return null;
                  } else
                    return "Please enter a value";
                },
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 2,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 220),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        label: Text("From"),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.edit_calendar_sharp),
                        isDense: true,
                      ),

                      child: TextButton(
                        onPressed: () async {
                          _selectedStartDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          _selectedStartDate =
                              _selectedStartDate ?? DateTime.now();
                          setState(() {
                            _selectedStartDate;
                          });
                        },

                        child: Text(
                          " ${dateFormat.format(_selectedStartDate!)}",
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Flexible(
                  flex: 1,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 130),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("At"),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,

                        prefixIcon: Icon(Icons.watch_later_outlined),
                      ),

                      child: TextButton(
                        onPressed: () async {
                          _selectedStartTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedStartTime!,
                          );

                          _selectedStartTime =
                              _selectedStartTime ?? TimeOfDay.now();

                          setState(() {
                            _selectedStartTime;
                          });
                        },

                        child: Text(_selectedStartTime!.format(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                Flexible(
                  flex: 2,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 220),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        label: Text("To"),
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.zero,
                        prefixIcon: Icon(Icons.edit_calendar_sharp),
                        isDense: true,
                      ),
                      child: TextButton(
                        onPressed: () async {
                          _selectedEndDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              const Duration(days: 365),
                            ),
                          );
                          _selectedEndDate = _selectedEndDate ?? DateTime.now();
                          setState(() {
                            _selectedEndDate;
                          });
                        },
                        child: Text(" ${dateFormat.format(_selectedEndDate!)}"),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 130),
                  child: Flexible(
                    flex: 1,
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        label: Text("At"),
                        contentPadding: EdgeInsets.zero,
                        isDense: true,

                        prefixIcon: Icon(Icons.watch_later_outlined),
                      ),
                      child: TextButton(
                        onPressed: () async {
                          _selectedEndTime = await showTimePicker(
                            context: context,
                            initialTime: _selectedEndTime!,
                          );

                          _selectedEndTime =
                              _selectedEndTime ?? TimeOfDay.now();

                          setState(() {
                            _selectedEndTime;
                          });
                        },
                        child: Text(_selectedEndTime!.format(context)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),

              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text("Room Number"),
                  prefixIcon: Icon(Icons.room_sharp),
                ),
                value: roomNbr,
                items: generateRoomNbrs(30).map((roomNbr) {
                  return DropdownMenuItem<int>(
                    value: roomNbr,
                    child: Text(roomNbr.toString()),
                  );
                }).toList(),
                onChanged: (nbr) {
                  roomNbr = nbr ?? 1;
                  setState(() {
                    roomNbr;
                  });
                },
                validator: (roomNbr) {
                  if (roomNbr == null) {
                    return "please enter a valid room number";
                  }
                  return null;
                },
              ),
            ),

            Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12),

              child: InputDecorator(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  label: Text('Recurrence'),
                ),
                child: Column(
                  children: _recurrence.map((rec) {
                    return ListTile(
                      leading: Radio<String>(
                        value: rec,
                        groupValue: _chosedRec,

                        onChanged: (rec) {
                          setState(() {
                            _chosedRec = rec!;
                          });
                        },
                        activeColor: Colors.purpleAccent,
                      ),
                      title: Text(rec),
                    );
                  }).toList(),
                ),
              ),
            ),
            if (_chosedRec == "Weekly")
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 12),

                child: InputDecorator(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    label: Text('Days of Week'),
                  ),
                  child: Wrap(
                    spacing: 10,
                    children: _daysOfWeek.map((day) {
                      final isSelected = _selectedDays.contains(day);
                      return FilterChip(
                        label: Text(day),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedDays.add(day);
                            } else {
                              _selectedDays.remove(day);
                            }
                          });
                        },
                        selectedColor: Colors.purpleAccent,
                      );
                    }).toList(),
                  ),
                ),
              ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
