import 'package:minijobs_mobile/models/job_type.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class JobTypeProvider extends BaseProvider<JobType> {
  JobTypeProvider(): super("jobtypes");
    @override
  JobType fromJson(data) {
    return JobType.fromJson(data);
  }
}