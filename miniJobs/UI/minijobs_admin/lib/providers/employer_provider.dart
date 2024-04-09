import 'package:minijobs_admin/models/employer.dart';
import 'package:minijobs_admin/providers/base_provider.dart';

class EmployerProvider extends BaseProvider<Employer> {
  EmployerProvider(): super("employers");
    @override
  Employer fromJson(data) {
    return Employer.fromJson(data);
  }
}