import 'package:flutter/material.dart';

class UserProfileWidget extends StatelessWidget {
  final String initials;
  final String username;
  final String email;

  const UserProfileWidget({
    Key? key,
    required this.initials,
    required this.username,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 125, vertical: 30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.yellow, Colors.black54, Colors.black],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.5,
              red: 0,
              green: 0,
              blue: 0,
            ),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Avatar + Edit Button
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 45,
                backgroundColor: Colors.amber[600],
                child: Text(
                  initials,
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),

              GestureDetector(
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor: Colors.black,
                  child: const Icon(Icons.edit, size: 18, color: Colors.amber),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Username
          Text(
            username,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),

          // Email
          Text(email, style: TextStyle(fontSize: 15, color: Colors.grey[300])),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
