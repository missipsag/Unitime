import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const ProviderScope(child: UniTimeApp()));
}

/// ----------------------
/// Models
/// ----------------------
enum CourseType { CM, TD, TP }

class Course {
  final String id;
  final String title;
  final String room;
  final CourseType type;
  final int dayIndex; // 0 = Monday, ... 5 = Saturday
  final int slotIndex; // row index (0 => first timeslot)
  final int durationSlots; // how many rows tall

  Course({
    required this.id,
    required this.title,
    required this.room,
    required this.type,
    required this.dayIndex,
    required this.slotIndex,
    this.durationSlots = 1,
  });

  Course copyWith({
    String? id,
    String? title,
    String? room,
    CourseType? type,
    int? dayIndex,
    int? slotIndex,
    int? durationSlots,
  }) {
    return Course(
      id: id ?? this.id,
      title: title ?? this.title,
      room: room ?? this.room,
      type: type ?? this.type,
      dayIndex: dayIndex ?? this.dayIndex,
      slotIndex: slotIndex ?? this.slotIndex,
      durationSlots: durationSlots ?? this.durationSlots,
    );
  }
}

/// ----------------------
/// State management (simple in-memory store)
/// Replace repository implementation later with local DB + sync
/// ----------------------
class TimetableNotifier extends StateNotifier<List<Course>> {
  TimetableNotifier() : super(_initialSample());

  static List<Course> _initialSample() {
    return [
      Course(
        id: 'c1',
        title: 'Algo',
        room: 'Salle 104',
        type: CourseType.CM,
        dayIndex: 0,
        slotIndex: 2,
      ),
      Course(
        id: 'c2',
        title: 'Prog Java',
        room: 'Salle 305',
        type: CourseType.TP,
        dayIndex: 1,
        slotIndex: 0,
        durationSlots: 1,
      ),
      Course(
        id: 'c3',
        title: 'Reseaux',
        room: 'Salle 201',
        type: CourseType.TD,
        dayIndex: 3,
        slotIndex: 1,
      ),
      Course(
        id: 'c4',
        title: 'Structures Machines',
        room: 'Salle 204',
        type: CourseType.CM,
        dayIndex: _todayIndexIfInRange(),
        slotIndex: 0,
      ),
    ];
  }

  static int _todayIndexIfInRange() {
    final wd = DateTime.now().weekday; // 1 = Mon ... 7 = Sun
    if (wd >= 1 && wd <= 6) return wd - 1;
    return 0; // fallback to Monday if weekend
  }

  void addCourse(Course course) {
    state = [...state, course];
  }

  void removeCourse(String id) {
    state = state.where((c) => c.id != id).toList();
  }

  void updateCourse(Course updated) {
    state = state.map((c) => c.id == updated.id ? updated : c).toList();
  }

  List<Course> coursesForCell(int dayIndex, int slotIndex) {
    return state.where((c) {
      final start = c.slotIndex;
      final end = c.slotIndex + c.durationSlots - 1;
      return c.dayIndex == dayIndex && slotIndex >= start && slotIndex <= end;
    }).toList();
  }
}

final timetableProvider =
    StateNotifierProvider<TimetableNotifier, List<Course>>((ref) {
      return TimetableNotifier();
    });

/// Simple admin flag provider (toggle to simulate admin/non-admin)
final isAdminProvider = Provider<bool>((ref) => true);

/// ----------------------
/// UI
/// ----------------------
class UniTimeApp extends StatelessWidget {
  const UniTimeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniTime',
      theme: ThemeData(
        primaryColor: const Color(0xFF3F51B5),
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF3F51B5)),
        fontFamily: 'Roboto',
      ),
      home: const TimetableScreen(),
    );
  }
}

class TimetableScreen extends ConsumerWidget {
  const TimetableScreen({super.key});

  static const List<String> dayNames = [
    'Lun',
    'Mar',
    'Mer',
    'Jeu',
    'Ven',
    'Sam',
  ];

  static const List<String> timeSlots = [
    '08:00',
    '10:00',
    '13:00',
    '15:00',
    '17:00',
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final courses = ref.watch(timetableProvider);
    final isAdmin = ref.watch(isAdminProvider);
    final todayWeekday = DateTime.now().weekday; // 1..7

    return Scaffold(
      appBar: AppBar(
        title: const Text('L3 Info - Groupe A'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_month),
            onPressed: () {
              // TODO: open week picker
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Change week (TODO)')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // TODO: settings screen
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Settings (TODO)')));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Days header
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                const SizedBox(width: 70), // left column for time labels
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(dayNames.length, (i) {
                      final isToday = todayWeekday == i + 1;
                      return Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: isToday ? const Color(0xFFFFF59D) : null,
                          ),
                          child: Center(
                            child: Text(
                              dayNames[i],
                              style: TextStyle(
                                fontWeight: isToday
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),

          // Timetable grid
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(timeSlots.length, (slotIdx) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Time label column
                      Container(
                        width: 70,
                        height: 120,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.all(8),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              timeSlots[slotIdx],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Days columns for this time slot
                      Expanded(
                        child: Row(
                          children: List.generate(dayNames.length, (dayIdx) {
                            final cellCoursesProvider = ref
                                .read(timetableProvider.notifier)
                                .coursesForCell(dayIdx, slotIdx);
                            final hasCourse = cellCoursesProvider.isNotEmpty;
                            final course = hasCourse
                                ? cellCoursesProvider.first
                                : null;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if (course != null) {
                                    _showCourseDetails(context, ref, course);
                                  } else {
                                    // non-admins can view; admins can add directly
                                    if (isAdmin) {
                                      _showAddCourseDialog(
                                        context,
                                        ref,
                                        preselectedDay: dayIdx,
                                        preselectedSlot: slotIdx,
                                      );
                                    }
                                  }
                                },
                                child: Container(
                                  height: 120,
                                  margin: const EdgeInsets.all(6),
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: hasCourse
                                        ? _colorForCourseType(course!.type)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    boxShadow: [
                                      if (hasCourse)
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.04),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                    ],
                                  ),
                                  child: hasCourse
                                      ? Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              course!.title,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              course.room,
                                              style: const TextStyle(
                                                color: Colors.white70,
                                              ),
                                            ),
                                            const Spacer(),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.white24,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: Text(
                                                  course.type.name,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      : Center(
                                          child: Text(
                                            '—',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                            ),
                                          ),
                                        ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: isAdmin
          ? FloatingActionButton(
              onPressed: () {
                _showAddCourseDialog(context, ref);
              },
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: 'Emploi'),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Mises à jour',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        ],
      ),
    );
  }

  static Color _colorForCourseType(CourseType t) {
    switch (t) {
      case CourseType.CM:
        return const Color(0xFFFB8C00); // orange
      case CourseType.TD:
        return const Color(0xFF43A047); // green
      case CourseType.TP:
        return const Color(0xFF1E88E5); // blue
    }
  }

  void _showCourseDetails(BuildContext context, WidgetRef ref, Course course) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(course.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Type: ${course.type.name}'),
            Text('Salle: ${course.room}'),
            Text('Jour: ${dayNames[course.dayIndex]}'),
            Text('Heure: ${timeSlots[course.slotIndex]}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          TextButton(
            onPressed: () {
              ref.read(timetableProvider.notifier).removeCourse(course.id);
              Navigator.of(ctx).pop();
            },
            child: const Text('Supprimer', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showAddCourseDialog(
    BuildContext context,
    WidgetRef ref, {
    int? preselectedDay,
    int? preselectedSlot,
  }) {
    final titleCtrl = TextEditingController();
    final roomCtrl = TextEditingController();
    CourseType selectedType = CourseType.TP;
    int day = preselectedDay ?? 0;
    int slot = preselectedSlot ?? 0;

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Ajouter un cours'),
        content: StatefulBuilder(
          builder: (ctx2, setState) {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleCtrl,
                    decoration: const InputDecoration(labelText: 'Intitulé'),
                  ),
                  TextField(
                    controller: roomCtrl,
                    decoration: const InputDecoration(labelText: 'Salle'),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Type:'),
                      const SizedBox(width: 8),
                      DropdownButton<CourseType>(
                        value: selectedType,
                        items: CourseType.values
                            .map(
                              (t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              ),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => selectedType = v!),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Text('Jour:'),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: day,
                        items: List.generate(
                          dayNames.length,
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(dayNames[i]),
                          ),
                        ),
                        onChanged: (v) => setState(() => day = v!),
                      ),
                      const SizedBox(width: 16),
                      const Text('Heure:'),
                      const SizedBox(width: 8),
                      DropdownButton<int>(
                        value: slot,
                        items: List.generate(
                          timeSlots.length,
                          (i) => DropdownMenuItem(
                            value: i,
                            child: Text(timeSlots[i]),
                          ),
                        ),
                        onChanged: (v) => setState(() => slot = v!),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              final newCourse = Course(
                id: DateTime.now().millisecondsSinceEpoch.toString(),
                title: titleCtrl.text.isNotEmpty ? titleCtrl.text : 'Cours',
                room: roomCtrl.text.isNotEmpty ? roomCtrl.text : 'Salle ?',
                type: selectedType,
                dayIndex: day,
                slotIndex: slot,
              );
              ref.read(timetableProvider.notifier).addCourse(newCourse);
              Navigator.of(ctx).pop();
            },
            child: const Text('Ajouter'),
          ),
        ],
      ),
    );
  }
}
