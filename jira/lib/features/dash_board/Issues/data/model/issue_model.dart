import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';

class IssueModel extends IssueEntity {
  IssueModel({
    required super.id,
    required super.projectId,
    required super.title,
    required super.summary,
    super.description,
    super.type,
    super.priority,
    super.status,
    super.assigneeId,
    super.reporterId,
    super.parentId,
    super.subTasks,
    required super.createdAt,
    required super.updatedAt,
  });


  factory IssueModel.fromMap(Map<String, dynamic> map) {
    return IssueModel(
      id: map['id'] ?? "",
      projectId: map['projectId'] ?? "",
      title: map['title'] ?? "",
      summary: map['summary'] ?? "",
      description: map['description'] ?? "",
      type: map['type'] ?? "task",
      priority: map['priority'] ?? "Low",
      status: map['status'] ?? "todo",
      assigneeId: map['assigneeId'],
      reporterId: map['reporterId'],
      parentId: map['parentId'],
      subTasks: List<String>.from(map['subTasks'] ?? []),
      createdAt: map['createdAt'] is Timestamp
          ? (map['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: map['updatedAt'] is Timestamp
          ? (map['updatedAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "projectId": projectId,
      "title": title,
      "summary": summary,
      "description": description,
      "type": type,
      "priority": priority,
      "status": status,
      "assigneeId": assigneeId,
      "reporterId": reporterId,
      "parentId": parentId,
      "subTasks": subTasks,
      "createdAt": createdAt,
      "updatedAt": updatedAt,
    };
  }


  IssueEntity toEntity() {
    return IssueEntity(
      id: id,
      projectId: projectId,
      title: title,
      summary: summary,
      description: description,
      type: type,
      priority: priority,
      status: status,
      assigneeId: assigneeId,
      reporterId: reporterId,
      parentId: parentId,
      subTasks: subTasks,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }


  factory IssueModel.fromEntity(IssueEntity entity) {
    return IssueModel(
      id: entity.id,
      projectId: entity.projectId,
      title: entity.title,
      summary: entity.summary,
      description: entity.description,
      type: entity.type,
      priority: entity.priority,
      status: entity.status,
      assigneeId: entity.assigneeId,
      reporterId: entity.reporterId,
      parentId: entity.parentId,
      subTasks: entity.subTasks,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
