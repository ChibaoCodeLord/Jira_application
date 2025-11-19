import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';

abstract class IssueRepository {
  Future<List<IssueEntity>> getIssuesByProject(String projectId);
  Future<IssueEntity> getIssueById(String issueId);
  Future<List<IssueEntity>> getIssuesByAssignee(String assigneeId);
  Future<IssueEntity> createIssue(IssueEntity issue);
  // Future<void> updateIssue(Issue issue);
  // Future<void> deleteIssue(String issueId);
}
