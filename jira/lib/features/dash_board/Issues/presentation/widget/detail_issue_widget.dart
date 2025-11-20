  import 'package:flutter/material.dart';
import 'package:jira/features/Users/model/user_model.dart';
  
  Color getPriorityColor(String? priority) {
    switch (priority?.toLowerCase()) {
      case 'low':
        return Colors.green;
      case 'medium':
        return Colors.orange;
      case 'high':
        return Colors.red;
      case 'critical':
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  Color getTypeColor(String? type) {
    switch (type?.toLowerCase()) {
      case 'task':
        return Colors.blue;
      case 'bug':
        return Colors.redAccent;
      case 'story':
        return Colors.teal;
      case 'sub-task':
        return Colors.orangeAccent;
      default:
        return Colors.grey;
    }
  }

  Widget buildUserAvatar(UserModel? user) {
    if (user == null) {
      return const Text("Unassigned", style: TextStyle(fontSize: 14));
    }
    return Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundColor: Colors.blueAccent,
          child: Text(
            user.firstName.isNotEmpty ? user.firstName[0] : '?',
            style: const TextStyle(color: Colors.white, fontSize: 14),
          ),
        ),
        const SizedBox(width: 8),
        Text("${user.firstName} ${user.lastName}", style: const TextStyle(fontSize: 14)),
      ],
    );
  }