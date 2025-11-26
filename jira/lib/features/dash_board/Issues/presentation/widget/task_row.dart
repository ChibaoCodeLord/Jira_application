import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';
import 'package:flutter/material.dart';

class TaskRow extends StatelessWidget {
  final IssueEntity task;
  final Function(String)? onStatusChanged;

  const TaskRow({
    super.key, 
    required this.task,
    this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getPriorityColors(task.priority);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border(
              left: BorderSide(
                color: colors['accent']!,
                width: 5,
              ),
            ),
          ),
          child:Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// ---------- TITLE WITH TYPE ----------
      Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              task.type.toUpperCase(),
              style: TextStyle(
                color: Colors.blue.shade700,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              task.title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
                height: 1.4,
                letterSpacing: -0.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),

      const SizedBox(height: 14),

      /// ---------- STATUS & DATE ----------
      Row(
        children: [
          Icon(
            Icons.calendar_today_rounded,
            size: 16,
            color: Colors.grey.shade600,
          ),
          const SizedBox(width: 6),
          Text(
            _formatDate(task.createdAt),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w500,
            ),
          ),
          
          const Spacer(),
          
          _buildStatusDropdown(task.status),
        ],
      ),
    ],
  ),
),

        ),
      ),
    );
  }




  // ===================================================================
  // FORMAT DATE
  // ===================================================================
  String _formatDate(DateTime? date) {
    if (date == null) return 'No date';
    
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  // ===================================================================
  // PRIORITY COLORS
  // ===================================================================
  Map<String, Color> _getPriorityColors(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return {
          'accent': const Color.fromARGB(255, 255, 0, 0),
        };
      case 'medium':
        return {
          'accent': const Color.fromARGB(255, 255, 221, 0),
        };
      default: // low
        return {
          'accent': const Color.fromARGB(255, 0, 255, 42),
        };
    }
  }

  // ===================================================================
  // STATUS DROPDOWN
  // ===================================================================
  Widget _buildStatusDropdown(String status) {
  final statusData = _getStatusData(status);
      const Map<String, String> statusLabelMap = {
        'todo': 'To Do',
        'inProgress': 'In Progress',
        'done': 'Done',
        'blocked': 'Blocked',
      };

      const Map<String, String> labelStatusMap = {
        'To Do': 'todo',
        'In Progress': 'inProgress',
        'Done': 'done',
        'Blocked': 'blocked',
      };

  return PopupMenuButton<String>(
  onSelected: (String selectedLabel) {
    final newStatus = labelStatusMap[selectedLabel]!; 
    if (onStatusChanged != null) {
      onStatusChanged!(newStatus);
    }
  },
  offset: const Offset(0, 50),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  color: Colors.white,
  elevation: 6,
  itemBuilder: (BuildContext context) => [
    _buildMenuItem(statusLabelMap['todo']!, Icons.play_circle_rounded, const Color(0xFF059669)),
    _buildMenuItem(statusLabelMap['inProgress']!, Icons.autorenew_rounded, const Color(0xFFF59E0B)),
    _buildMenuItem(statusLabelMap['done']!, Icons.check_circle_rounded, const Color(0xFF3B82F6)),
  ],
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: statusData['bgColor'],
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(statusData['icon'], size: 18, color: statusData['color']),
          const SizedBox(width: 8),
          Text(
            statusData['text'],
            style: TextStyle(
              color: statusData['color'],
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 6),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 20,
            color: statusData['color'],
          ),
        ],
      ),
    ),
  );
}

PopupMenuItem<String> _buildMenuItem(String status, IconData icon, Color color) {
  return PopupMenuItem<String>(
    value: status,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      color: Colors.white,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(width: 12),
          Text(
            status,
            style: const TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ),
  );
}



  // ===================================================================
  // GET STATUS DATA
  // ===================================================================
  Map<String, dynamic> _getStatusData(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return {
          'color': const Color(0xFF059669),
          'bgColor': const Color(0xFFECFDF5),
          'icon': Icons.play_circle_rounded,
          'text': 'Active',
        };
      case 'review':
        return {
          'color': const Color(0xFFF59E0B),
          'bgColor': const Color(0xFFFEF3C7),
          'icon': Icons.rate_review_rounded,
          'text': 'Review',
        };
      case 'done':
        return {
          'color': const Color(0xFF3B82F6),
          'bgColor': const Color(0xFFEFF6FF),
          'icon': Icons.check_circle_rounded,
          'text': 'Done',
        };
      case 'blocked':
        return {
          'color': const Color(0xFFEF4444),
          'bgColor': const Color(0xFFFEF2F2),
          'icon': Icons.block_rounded,
          'text': 'Blocked',
        };
      default:
        return {
          'color': const Color(0xFF6B7280),
          'bgColor': const Color(0xFFF3F4F6),
          'icon': Icons.fiber_manual_record,
          'text': status,
        };
    }
  }
}