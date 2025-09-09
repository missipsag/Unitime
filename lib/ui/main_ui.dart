import 'package:flutter/material.dart';

class MainUi extends StatefulWidget {
  const MainUi({super.key});

  @override
  State<MainUi> createState() => _MainUiState();
}

class _MainUiState extends State<MainUi> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      height: 100.0,
      color: Colors.white,
      alignment: AlignmentGeometry.directional(0.0, 0.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 100.0,
        children: [
          Text(
            "Stay sync with you class",
            style: TextStyle(fontSize: 20.0, height: 10.0),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.0,
            children: [
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: BeveledRectangleBorder(),
                  elevation: 4.0,
                ),
                child: const Text("Join groupe"),
              ),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueGrey,
                  foregroundColor: Colors.white,
                  shape: const BeveledRectangleBorder(),
                  elevation: 4.0,
                ),
                child: const Text("Create a group"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
