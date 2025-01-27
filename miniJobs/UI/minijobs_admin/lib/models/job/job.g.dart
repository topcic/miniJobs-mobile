part of 'job.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Job _$JobFromJson(Map<String, dynamic> json) => Job()
  ..id = (json['id'] as num?)?.toInt()
  ..name = json['name'] as String?
  ..description = json['description'] as String?
  ..streetAddressAndNumber = json['streetAddressAndNumber'] as String?
  ..city = json['city'] == null
      ? null
      : City.fromJson(json['city'] as Map<String, dynamic>)
  ..applicationsDuration = (json['applicationsDuration'] as num?)?.toInt()
  ..status = jobStatusFromInt(json['status'] as int?)
  ..requiredEmployees = (json['requiredEmployees'] as num?)?.toInt()
  ..wage = (json['wage'] as num?)?.toInt()
  ..employer = json['employer'] == null
      ? null
      : Employer.fromJson(json['employer'] as Map<String, dynamic>)
  ..state = (json['state'] as num?)?.toInt()
  ..cityId = (json['cityId'] as num?)?.toInt()
  ..created =
      json['created'] == null ? null : DateTime.parse(json['created'] as String)
  ..numberOfApplications = (json['numberOfApplications'] as num?)?.toInt()
  ..jobTypeId = (json['jobTypeId'] as num?)?.toInt()
  ..jobType = json['jobType'] == null
      ? null
      : JobType.fromJson(json['jobType'] as Map<String, dynamic>)
  ..schedules = (json['schedules'] as List<dynamic>?)
      ?.map((e) =>
          e == null ? null : ProposedAnswer.fromJson(e as Map<String, dynamic>))
      .whereType<ProposedAnswer>() // Filter out null values
      .toList()
  ..paymentQuestion = json['paymentQuestion'] == null
      ? null
      : ProposedAnswer.fromJson(json['paymentQuestion'] as Map<String, dynamic>)
  ..additionalPaymentOptions = (json['additionalPaymentOptions']
          as List<dynamic>?)
      ?.map((e) =>
          e == null ? null : ProposedAnswer.fromJson(e as Map<String, dynamic>))
      .whereType<ProposedAnswer>() // Filter out null values
      .toList()
  ..employerFullName = json['employerFullName'] as String?
  ..isApplied = (json['isApplied'] as bool?) ?? false // Default to false
  ..isSaved = (json['isSaved'] as bool?) ?? false // Default to false
  ..createdBy = (json['createdBy'] as num?)?.toInt()
  ..applicationsStart =
  json['applicationsStart'] == null ? null : DateTime.parse(json['applicationsStart'] as String)
  ..deletedByAdmin=(json['deletedByAdmin'] as bool?) ?? false ;

Map<String, dynamic> _$JobToJson(Job instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'streetAddressAndNumber': instance.streetAddressAndNumber,
      'city': instance.city,
      'applicationsDuration': instance.applicationsDuration,
      'status': instance.status?.index,
      'requiredEmployees': instance.requiredEmployees,
      'wage': instance.wage,
      'employer': instance.employer,
      'state': instance.state,
      'cityId': instance.cityId,
      'created': instance.created?.toIso8601String(),
      'numberOfApplications': instance.numberOfApplications,
      'jobTypeId': instance.jobTypeId,
      'jobType': instance.jobType,
      'schedules': instance.schedules,
      'paymentQuestion': instance.paymentQuestion,
      'additionalPaymentOptions': instance.additionalPaymentOptions,
      'employerFullName': instance.employerFullName,
      'isApplied': instance.isApplied,
      'isSaved': instance.isSaved,
      'createdBy': instance.createdBy,
  'deletedByAdmin':instance.deletedByAdmin
    };

JobStatus? jobStatusFromInt(int? status) {
  if (status == null) return null;
  switch (status) {
    case 0:
      return JobStatus.Kreiran;
    case 1:
      return JobStatus.Aktivan;
    case 2:
      return JobStatus.AplikacijeZavrsene;
    case 3:
      return JobStatus.Zavrsen;
    case 4:
      return JobStatus.Izbrisan;
    default:
      return null;
  }
}
