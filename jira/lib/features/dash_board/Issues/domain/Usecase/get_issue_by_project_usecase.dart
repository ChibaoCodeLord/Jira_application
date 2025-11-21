import 'package:injectable/injectable.dart';
import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';
import 'package:jira/features/dash_board/Issues/domain/Repositories/issue_repository.dart';

@injectable
class GetIssueByProjectUsecase {
  final IssueRepository repository;
  
  GetIssueByProjectUsecase(this.repository);
  Future<List<IssueEntity>> call(String idProject) async {
    return repository.getIssuesByProject(idProject);
  }
}
