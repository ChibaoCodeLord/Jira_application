
import 'package:injectable/injectable.dart';
import 'package:jira/features/dash_board/Issues/domain/Repositories/issue_repository.dart';

@injectable
class DeleteIssueUsecase {
  final IssueRepository repository;
  
  DeleteIssueUsecase(this.repository);
  Future<bool> call(String idIssue) {
    return repository.deleteIssue(idIssue);
  }
}
