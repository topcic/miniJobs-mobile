
import 'package:json_annotation/json_annotation.dart';

part 'rating_save_request.g.dart';

@JsonSerializable()
class RatingSaveRequest {
  String comment;
  int value;
  int jobApplicationId;
  int ratedUserId;
  RatingSaveRequest(
      this.comment,
      this.value,
      this.jobApplicationId,
      this.ratedUserId
      );

  factory RatingSaveRequest.fromJson(Map<String, dynamic> json) => _$RatingSaveRequestFromJson(json);

  Map<String, dynamic> toJson() => _$RatingSaveRequestToJson(this);
}
