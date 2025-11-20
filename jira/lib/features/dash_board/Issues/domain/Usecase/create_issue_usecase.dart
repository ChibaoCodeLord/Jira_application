
import 'package:injectable/injectable.dart';
import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';
import 'package:jira/features/dash_board/Issues/domain/Repositories/issue_repository.dart';

@injectable
class CreateIssueUsecase {
  final IssueRepository repository;
  
  CreateIssueUsecase(this.repository);
  Future<IssueEntity> call(IssueEntity issue) {
    return repository.createIssue(issue);
  }
}
