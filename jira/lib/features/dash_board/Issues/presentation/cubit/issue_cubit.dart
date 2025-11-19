import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:jira/features/dash_board/Issues/presentation/cubit/issue_state.dart';
import 'package:jira/features/dash_board/Issues/domain/Usecase/create_issue_usecase.dart';
import 'package:jira/features/dash_board/Issues/domain/Usecase/get_issue_by_id.dart';
import 'package:jira/features/dash_board/Issues/domain/Usecase/get_issue_by_project_usecase.dart';
import 'package:jira/features/dash_board/Issues/domain/Usecase/get_issues_by_assignee.dart';


@injectable
class IssueCubit extends Cubit<IssueState> {
  final CreateIssueUsecase createIssueUsecase;
  final GetIssueByProjectUsecase getIssueByProjectUsecase;
  final GetIssuesByAssigneeUsecase getIssuesByAssigneeUsecase;
  final GetIssueByIdUsecase getIssueByIdUsecase;
  IssueCubit(
      this.createIssueUsecase,
      this.getIssueByProjectUsecase,
      this.getIssuesByAssigneeUsecase,
      this.getIssueByIdUsecase,
      ) : super(IssueState());

  Future<void> loadIssuesByProject(String projectId) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final issues = await getIssueByProjectUsecase(projectId);
      final todo = issues.where((issue) => issue.status == 'To Do').toList();
      final inProgress = issues.where((issue) => issue.status == 'In Progress').toList();
      final done = issues.where((issue) => issue.status == 'Done').toList();
      emit(state.copyWith(isLoading : false, todo: todo, inProgress: inProgress, done: done));
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()));
    }
  }
}
