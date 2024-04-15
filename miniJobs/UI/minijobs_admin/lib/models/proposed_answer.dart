import 'package:json_annotation/json_annotation.dart';

part 'proposed_answer.g.dart';

@JsonSerializable()
class ProposedAnswer {
  int? id;
  String? answer;
  int? questionId;

  ProposedAnswer(this.id, this.answer, this.questionId);

  factory ProposedAnswer.fromJson(Map<String, dynamic> json) => _$ProposedAnswerFromJson(json);

  Map<String, dynamic> toJson() => _$ProposedAnswerToJson(this);
}
