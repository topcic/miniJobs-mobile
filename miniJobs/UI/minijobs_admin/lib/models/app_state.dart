import 'package:meta/meta.dart';
import 'package:minijobs_admin/models/job/job_state.dart';


@immutable
class AppState {
  final JobState job;

  AppState({
   required  this.job,
  });

  factory AppState.initial() => AppState(
    job: JobState.initial(),
  );

  AppState copyWith({
    required JobState job,
  }) {
    return AppState(
      job: job ?? this.job,
    );
  }
}