// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proposed_answer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProposedAnswer _$ProposedAnswerFromJson(Map<String, dynamic> json) =>
    ProposedAnswer(
      (json['id'] as num?)?.toInt(),
      json['answer'] as String?,
      (json['questionId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProposedAnswerToJson(ProposedAnswer instance) =>
    <String, dynamic>{
      'id': instance.id,
      'answer': instance.answer,
      'questionId': instance.questionId,
    };
