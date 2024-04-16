
import 'package:minijobs_admin/models/job/job.dart';

class JobState {
  ListJobsState list;
 // UserDetailsState details;

  JobState({
   required this.list,
 //   this.details,
  });

  factory JobState.initial() => JobState(
    list: ListJobsState.initial(),
 //   details: UserDetailsState.initial(),
  );
}

class ListJobsState {
  dynamic error;
  bool loading;
  List<Job> data;

  ListJobsState({
    this.error,
    required this.loading,
    required this.data,
  });

  factory ListJobsState.initial() => ListJobsState(
        error: null,
        loading: false,
        data: [], // Initialize as an empty list
      );
}
// class UserDetailsState {
//   dynamic error;
//   bool loading;
//   UserDetails data;

//   UserDetailsState({
//     this.error,
//     this.loading,
//     this.data,
//   });

//   factory UserDetailsState.initial() => UserDetailsState(
//     error: null,
//     loading: false,
//     data: null,
//   );
// }