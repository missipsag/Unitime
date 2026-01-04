import 'package:flutter/material.dart';
import 'package:unitime/repository/uni_appointment_repository.dart';
import 'package:unitime/ui/calendar_view.dart';
import 'package:unitime/ui/feed_view.dart';
import 'package:unitime/ui/profile_view.dart';
import 'package:unitime/ui/updates_view.dart';
import 'package:unitime/viewmodels/calendar_view_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UniTime',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyHomePage(title: "UniTime"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;
  final _pages = const [
    FeedView(),
    //CalendarView(),
    UpdatesView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    CalendarViewModel viewModel = CalendarViewModel(
      uniAppointmentRepository: UniAppointmentRepository(),
    );
    return Scaffold(
      body: CalendarView(viewModel: viewModel),
      bottomNavigationBar: _bottomNavBar(context),
    );
  }

  Container _bottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadiusGeometry.all(Radius.circular(15)),
        color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 0;
              });
            },
            icon: _currentIndex == 0
                ? Icon(Icons.home_filled)
                : Icon(Icons.home_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 1;
              });
            },
            icon: _currentIndex == 1
                ? Icon(Icons.watch_later_rounded)
                : Icon(Icons.watch_later_outlined),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 2;
              });
            },
            icon: _currentIndex == 2
                ? Icon(Icons.notifications)
                : Icon(Icons.notifications_none),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                _currentIndex = 3;
              });
            },
            icon: _currentIndex == 3
                ? Icon(Icons.person)
                : Icon(Icons.person_outline_outlined),
          ),
        ],
      ),
    );
  }
}
