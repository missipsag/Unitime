import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:unitime/core/constants/uni_appointment_types.dart';
import 'package:unitime/service/appointment_service.dart';
import 'package:unitime/ui/gpt_ui.dart';

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
    return Dialog(
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black,
                offset: Offset(6, 6),
                spreadRadius: 2,
                blurStyle: BlurStyle.solid,
              ),
            ],
          ),
          padding: const EdgeInsets.all(12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Align(
                  alignment: Alignment.topRight,
                  child: CloseButton(),
                ),
                const Center(
                  child: Text(
                    "Category ",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 175, 175, 175),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: _type,
                    decoration: const InputDecoration(border: InputBorder.none),
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
                const Center(child: Text("Subject")),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 175, 175, 175),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: TextFormField(
                    controller: _subjectController,
                    validator: (value) {
                      if (value!.isNotEmpty) {
                        return null;
                      } else
                        return "Please enter a value";
                    },
                  ),
                ),
                Container(
                  alignment: Alignment.center,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      TextButton(
                        onPressed: () async {
                          _selectedStartDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.utc(2025, 1, 1),
                            lastDate: DateTime.utc(2025, 12, 31),
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
                      TextButton(
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
                    ],
                  ),
                ),

                Container(
                  alignment: Alignment.center,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                    children: [
                      TextButton(
                        onPressed: () async {
                          _selectedEndDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.utc(2025, 1, 1),
                            lastDate: DateTime.utc(2025, 12, 31),
                          );
                          _selectedEndDate = _selectedEndDate ?? DateTime.now();
                          setState(() {
                            _selectedEndDate;
                          });
                        },
                        child: Text(" ${dateFormat.format(_selectedEndDate!)}"),
                      ),
                      TextButton(
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
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 175, 175, 175),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: DropdownButtonFormField(
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
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 175, 175, 175),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: TextButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        _selectedType = stringToUniApp[_type];

                        _appointmentService.createAppointment(
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
                        );
                        
                        Navigator.of(context).pop();
                      }
                    },
                    child: const Text("Add"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
