import 'package:json_annotation/json_annotation.dart';

import '../../enumerations/job_statuses.dart';
import '../proposed_answer.dart';

part 'job_card_dto.g.dart';

@JsonSerializable()
class JobCardDTO {
  int id;
  String name;
  String cityName;
  int? wage;


  JobCardDTO(this.id,
      this.name,
      this.cityName,
      this.wage);

  factory JobCardDTO.fromJson(Map<String, dynamic> json) => _$JobCardDTOFromJson(json);

}