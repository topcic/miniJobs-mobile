// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'applicant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Applicant _$ApplicantFromJson(Map<String, dynamic> json) => Applicant(
      (json['id'] as num?)?.toInt(),
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['fullName'] as String?,
      json['email'] as String?,
      json['phoneNumber'] as String?,
      json['role'] as String?,
      json['deleted'] as bool?,
      json['accountConfirmed'] as bool?,
      json['photo'] == null ? null : base64Decode(json['photo'] as String),
      (json['cityId'] as num?)?.toInt(),
      json['city'] == null
          ? null
          : City.fromJson(json['city'] as Map<String, dynamic>),
      json['cv'] == null ? null : base64Decode(json['cv'] as String),
      json['description'] as String?,
      json['experience'] as String?,
      json['wageProposal'] != null
          ? Decimal.parse(json['wageProposal'].toString())
          : null,
      json['jobType'] == null
          ? null
          : JobType.fromJson(json['jobType'] as Map<String, dynamic>),
      (json['numberOfFinishedJobs'] as num?)?.toInt(),
      json['averageRating'] != null
          ? Decimal.parse(json['averageRating'].toString())
          : null,
    (json['jobTypes'] as List<dynamic>?)
        ?.map((e) => JobType.fromJson(e as Map<String, dynamic>))
        .toList(),
      (json['jobApplicationId'] as num?)?.toInt(),
      json['isRated'] as bool?,
      jobApplicationStatusFromInt(json['applicationStatus'] as int?),
);

Map<String, dynamic> _$ApplicantToJson(Applicant instance) => <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'email': instance.email,
      'phoneNumber': instance.phoneNumber,
      'role': instance.role,
      'deleted': instance.deleted,
      'accountConfirmed': instance.accountConfirmed,
      'photo': instance.photo == null ? null : base64Encode(instance.photo!),
      'cv': instance.cv == null ? null : base64Encode(instance.cv!),
      'city': instance.city,
      'cityId': instance.cityId,
      'description': instance.description,
      'experience': instance.experience,
      'wageProposal': instance.wageProposal,
      'jobType': instance.jobType,
      'numberOfFinishedJobs': instance.numberOfFinishedJobs,
      'averageRating': instance.averageRating,
      'jobTypes': instance.jobTypes,
      'jobApplicationId': instance.jobApplicationId,
      'isRated': instance.isRated
};

JobApplicationStatus? jobApplicationStatusFromInt(int? status) {
      if (status == null) return null;
      switch (status) {
            case 0:
                  return JobApplicationStatus.Poslano;
            case 1:
                  return JobApplicationStatus.Prihvaceno;
            case 2:
                  return JobApplicationStatus.Odbijeno;
            default:
                  return null;
      }
}
