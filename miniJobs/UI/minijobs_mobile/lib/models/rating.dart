import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
  final int id;
  final String comment;
  final int value;
  final int jobApplicationId;
  final int ratedUserId;
  final String createdByFullName;
  final DateTime created;

  Rating({
    required this.id,
    required this.comment,
    required this.value,
    required this.jobApplicationId,
    required this.ratedUserId,
    required this.createdByFullName,
    required this.created,
  });

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
