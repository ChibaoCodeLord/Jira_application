import 'package:injectable/injectable.dart';
import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';
import 'package:jira/features/dash_board/Issues/domain/Repositories/issue_repository.dart';

@injectable
class GetIssueByIdUsecase {
  final IssueRepository repository;
  
  GetIssueByIdUsecase(this.repository);
  Future<IssueEntity> call(String  id) {
    return repository.getIssueById(id);
  }
}
