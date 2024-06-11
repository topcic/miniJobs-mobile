import 'package:minijobs_mobile/models/applicant.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class ApplicantProvider extends BaseProvider<Applicant> {
  ApplicantProvider() : super("applicants");
  @override
  Applicant fromJson(data) {
    return Applicant.fromJson(data);
  }
}
