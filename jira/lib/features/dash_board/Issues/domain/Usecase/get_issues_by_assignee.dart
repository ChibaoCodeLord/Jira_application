import 'package:injectable/injectable.dart';
import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';
import 'package:jira/features/dash_board/Issues/domain/Repositories/issue_repository.dart';

@injectable
class GetIssuesByAssigneeUsecase {
  final IssueRepository repository;
  
  GetIssuesByAssigneeUsecase(this.repository);
  Future<List<IssueEntity>> call(String idAssignee) {
    return repository.getIssuesByAssignee(idAssignee);
  }
}
