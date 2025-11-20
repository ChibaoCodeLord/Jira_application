import 'package:jira/features/dash_board/Issues/domain/Entity/issue_entity.dart';


class IssueState {
  final List<IssueEntity> todo;
  final List<IssueEntity> inProgress;
  final List<IssueEntity> done;
  final bool isLoading;
  final String? error;

  IssueState({
    this.todo = const [],
    this.inProgress = const [],
    this.done = const [],
    this.isLoading = false,
    this.error,
  });

  IssueState copyWith({
    List<IssueEntity>? todo,
    List<IssueEntity>? inProgress,
    List<IssueEntity>? done,
    bool? isLoading,
    String? error,
  }) {
    return IssueState(
      todo: todo ?? this.todo,
      inProgress: inProgress ?? this.inProgress,
      done: done ?? this.done,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}