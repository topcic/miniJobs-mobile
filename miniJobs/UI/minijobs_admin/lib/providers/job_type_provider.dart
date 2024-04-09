import 'package:minijobs_admin/models/job_type.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

class JobTypeProvider extends BaseProvider<JobType> {
  JobTypeProvider(): super("jobtypes");
    @override
  JobType fromJson(data) {
    return JobType.fromJson(data);
  }
}