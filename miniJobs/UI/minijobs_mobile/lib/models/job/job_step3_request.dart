import 'package:json_annotation/json_annotation.dart';

part 'job_step3_request.g.dart';

@JsonSerializable()
class JobStep3Request {
  Map<int, List<int>>? answersToPaymentQuestions;
  int? wage;

  JobStep3Request(this.answersToPaymentQuestions, this.wage);
  Map<String, dynamic> toJson() => _$JobStep3RequestToJson(this);
}
