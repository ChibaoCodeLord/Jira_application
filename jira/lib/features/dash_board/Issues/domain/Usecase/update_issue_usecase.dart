import 'package:injectable/injectable.dart';
import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';
import 'package:jira/features/dash_board/Issues/domain/Repositories/issue_repository.dart';

@injectable
class UpdateIssueUsecase {
  final IssueRepository repository;
  
  UpdateIssueUsecase(this.repository);
  Future<IssueEntity> call(IssueEntity issue) {
    return repository.updateIssue(issue);
  }
}
