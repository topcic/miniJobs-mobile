import 'dart:developer';

import 'package:minijobs_admin/models/job/job.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

class JobProvider extends BaseProvider<Job> {
  List<Job> _jobs = [];
  Job? _currentJob;
  JobProvider(): super("jobs");
    @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }
 Future<void> setCurrentJob(Job job) async {
  debugger();
    _currentJob = job;
    notifyListeners();
  }
    Job? getCurrentJob() {
  debugger();

    return _currentJob;
  }
}