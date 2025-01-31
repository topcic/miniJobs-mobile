import 'dart:convert';
import 'dart:typed_data';

import 'package:json_annotation/json_annotation.dart';

part 'rating.g.dart';

@JsonSerializable()
class Rating {
   int id;
   String comment;
   int value;
   int jobApplicationId;
   int ratedUserId;
   String createdByFullName;
   DateTime created;
   Uint8List? photo;
   int createdBy;
   String createdByRole;
   String ratedUserFullName;
   String ratedUserRole;
   bool isActive;

  Rating(
     this.id,
     this.comment,
     this.value,
     this.jobApplicationId,
     this.ratedUserId,
     this.createdByFullName,
     this.created,
      this.photo,
      this.createdBy,
      this.createdByRole,
      this.ratedUserFullName,
      this.ratedUserRole,
      this.isActive
  );

  factory Rating.fromJson(Map<String, dynamic> json) => _$RatingFromJson(json);

  Map<String, dynamic> toJson() => _$RatingToJson(this);
}
