
import 'package:flutter/material.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/job/job_save_request.dart';
import 'package:minijobs_mobile/models/job/job_schedule_info.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_preview.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_step_1.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_step_2.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_step_3.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobDetails extends StatefulWidget {
  final int jobId;

  const JobDetails({super.key, required this.jobId});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  int _currentStep = 0;
  bool isCompleted = false;
  late Job _job = Job();
  late JobProvider _jobProvider = JobProvider();
  final GlobalKey<JobStep1State> _jobStep1Key = GlobalKey<JobStep1State>();
  JobSaveRequest? _jobSaveRequest;
  late Function() _validateAndSaveStep2Callback;
  late Function() _validateAndSaveStep3Callback;

  void _nextPressed(Job job) {
    setState(() {
      if (_currentStep < getSteps().length - 1) {
        _currentStep += 1;
      } else {
        isCompleted = true;
      }
    });
  }
  bool isJobCompleted() {
  return _job.status == JobStatus.Zavrsen;
}

  @override
  void initState() {
    super.initState();
    if (widget.jobId != 0) {
      getjob();
    }
  }

  Future<void> getjob() async {
    final job = await _jobProvider.get(widget.jobId);
    _jobProvider.setCurrentJob(job);
    setState(() {
      _job = job; // Update _job with fetched data
    });
  }
JobSaveRequest createJobSaveRequest(Job job) {

  var schedules = job.schedules != null && job.schedules
  !.isNotEmpty
      ? JobScheduleInfo(
          job.schedules![0].questionId,
          job.schedules!.map((e) => e.id!).toList(),
        )
      : null;

  var answersToPaymentQuestions = job.additionalPaymentOptions != null
     && job.additionalPaymentOptions!.isNotEmpty ? job.additionalPaymentOptions!.fold<Map<int, List<int>>>(
          {},
          (map, answer) {
            if (answer.questionId != null && answer.id != null) {
              map.putIfAbsent(answer.questionId!, () => []).add(answer.id!);
            }
            return map;
          },
        )
      : null;
 
    return JobSaveRequest(
    job.id!,
    job.name,
    job.description,
    job.streetAddressAndNumber,
    job.cityId,
    job.status!.index,
    job.jobTypeId,
    job.requiredEmployees,
    schedules,
    answersToPaymentQuestions,
    job.wage,
    job.applicationsDuration
  );
}
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobProvider = Provider.of<JobProvider>(context);
  }

  void _onNextButton(bool isValid, JobSaveRequest? jobSaveRequest) async {
    if (isValid) {
      var saveRequest = jobSaveRequest;
      var job = await _jobProvider.update(saveRequest!.id!, saveRequest);
      _jobProvider.setCurrentJob(job);
      setState(() {
        _currentStep += 1;
      });
        }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Job Details'),
        ),
        body: isCompleted
        ? buildCompleted()
        : isJobCompleted()
            ? const JobPreview()  // Show only job preview if the job is completed
            : Stepper(
                type: StepperType.horizontal,
                steps: getSteps(),
                currentStep: _currentStep,
                onStepContinue: () async {
                  await nextStep();
                },
                onStepCancel: _currentStep == 0
                    ? null
                    : () {
                        setState(() {
                          _currentStep -= 1;
                        });
                      },
                onStepTapped: (step) {
                  setState(() {
                    _currentStep = step;
                  });
                },
                controlsBuilder: (context, details) {
                  final isLastStep = _currentStep == getSteps().length - 1;

                  return Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          if (_currentStep != 0)
                            Expanded(
                                child: ElevatedButton(
                              onPressed: details.onStepCancel,
                              child: const Text('Nazad'),
                            )),
                          const SizedBox(width: 10),
                          Expanded(
                              child: ElevatedButton(
                            onPressed: details.onStepContinue,
                            child: Text(isLastStep ? 'Objavi posao' : 'Dalje'),
                          ))
                        ],
                      ));
                },
              ));
  }

  List<Step> getSteps() => [
        Step(
          title: const Text(''),
          content: JobStep1(key: _jobStep1Key),
          isActive: _currentStep >= 0,
          state: _currentStep == 0
              ? StepState.editing
              : _currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
        ),
        Step(
          title: const Text(''),
          content: JobStep2(
              onNextButton: _onNextButton,
              setValidateAndSaveCallback: (Function() validateAndSave) {
                _validateAndSaveStep2Callback = validateAndSave;
              }),
          isActive: _currentStep >= 1,
          state: _currentStep == 0
              ? StepState.editing
              : _currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
        ),
        Step(
          title: const Text(''),
          content: JobStep3(
              onNextButton: _onNextButton,
              setValidateAndSaveCallback: (Function() validateAndSave) {
                _validateAndSaveStep3Callback = validateAndSave;
              }),
          isActive: _currentStep >= 2,
          state: _currentStep == 0
              ? StepState.editing
              : _currentStep > 2
                  ? StepState.complete
                  : StepState.indexed,
        ),
        Step(
          title: const Text(''),
          content: const JobPreview(),
          isActive: _currentStep >= 3,
          state: _currentStep == 3
              ? StepState.editing
              : _currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
        )
      ];

  Container buildCompleted() {
    return Container();
  }

  nextStep() async {
    if (_currentStep == 0) {
      var jobStep1State = _jobStep1Key.currentState;

      if (jobStep1State != null && jobStep1State.validateAndSave()) {
        _job = jobStep1State.getUpdatedJob();
        if (_job.id == null || _job.id == 0) {
          var job = await _jobProvider.insert(_job);
          setState(() {
            _job = job;
            _jobProvider.setCurrentJob(job);
            _currentStep += 1;
          });
                } else {
       var saveRequest= createJobSaveRequest(_job);
          var job = await _jobProvider.update(_job.id!, saveRequest);
          _jobProvider.setCurrentJob(job);
          setState(() {
            _job = job;
            _currentStep += 1;
          });
                }
      }
    } else if (_currentStep == 1) {
      _validateAndSaveStep2Callback();
    } else if (_currentStep == 2) {
      _validateAndSaveStep3Callback();
    } else if (_currentStep == 3) {
      var job = await _jobProvider.activate(_job.id!, JobStatus.Aktivan);
      _jobProvider.setCurrentJob(job);
      setState(() {
        isCompleted = true;
      });
        }
  }
}