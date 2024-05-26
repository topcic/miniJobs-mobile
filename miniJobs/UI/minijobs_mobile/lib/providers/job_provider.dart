import 'dart:developer';

import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class JobProvider extends BaseProvider<Job> {
  List<Job> _jobs = [];
  Job? _currentJob;
  JobProvider(): super("jobs");
    @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }
 Future<void> setCurrentJob(Job job) async {

    _currentJob = job;
    notifyListeners();
  }

  
    Job? getCurrentJob() {


    return _currentJob;
  }
}