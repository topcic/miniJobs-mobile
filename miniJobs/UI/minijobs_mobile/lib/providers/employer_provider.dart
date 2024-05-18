import 'package:minijobs_mobile/models/employer.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class EmployerProvider extends BaseProvider<Employer> {
  EmployerProvider(): super("employers");
    @override
  Employer fromJson(data) {
    return Employer.fromJson(data);
  }
}