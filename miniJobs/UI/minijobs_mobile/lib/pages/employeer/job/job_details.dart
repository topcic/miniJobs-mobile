import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/pages/employeer/job/steps/job_step_1.dart';
import 'package:minijobs_mobile/pages/employeer/job/steps/job_step_2.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobDetails extends StatefulWidget {
  final int jobId;

  JobDetails({required this.jobId});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  int _currentStep = 0;
  bool isCompleted = false;
  late Job _job = new Job();
  late JobProvider _jobProvider = JobProvider();
  final GlobalKey<JobStep1State> _jobStep1Key = GlobalKey<JobStep1State>();
  final GlobalKey<JobStep2State> _jobStep2Key = GlobalKey<JobStep2State>();
  void _nextPressed(Job job) {
    setState(() {
      if (_currentStep < getSteps().length - 1) {
        _currentStep += 1;
      } else {
        isCompleted = true;
      }
    });
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobProvider = Provider.of<JobProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Job Details'),
        ),
        body: isCompleted
            ? buildCompleted()
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
                      margin: EdgeInsets.only(top: 50),
                      child: Row(
                        children: [
                          if (_currentStep != 0)
                            Expanded(
                                child: ElevatedButton(
                              child: Text('Nazad'),
                              onPressed: details.onStepCancel,
                            )),
                          SizedBox(width: 10),
                          Expanded(
                              child: ElevatedButton(
                            child: Text(isLastStep ? 'Objavi posao' : 'Dalje'),
                            onPressed: details.onStepContinue,
                          ))
                        ],
                      ));
                },
              ));
  }

  List<Step> getSteps() => [
        Step(
          title: Text(''),
          content: JobStep1(key: _jobStep1Key),
          isActive: _currentStep >= 0,
          state: _currentStep == 0
              ? StepState.editing
              : _currentStep > 0
                  ? StepState.complete
                  : StepState.indexed,
        ),
        Step(
          title: Text(''),
          content: JobStep2(key: _jobStep2Key),
          isActive: _currentStep >= 1,
          state: _currentStep == 0
              ? StepState.editing
              : _currentStep > 1
                  ? StepState.complete
                  : StepState.indexed,
        ),
        Step(
          title: Text(''),
          content: Container(),
          isActive: _currentStep >= 2,
          state: _currentStep == 0
              ? StepState.editing
              : _currentStep > 2
                  ? StepState.complete
                  : StepState.indexed,
        ),
        Step(
          title: Text(''),
          content: Container(),
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
        if (_job.id == 0) {
          var job = await _jobProvider.insert(_job);
          if (job != null) {
            setState(() {
              _currentStep += 1;
            });
          }
        } else {
          var job = await _jobProvider.update(_job.id!, _job);
          if (job != null) {
            _jobProvider.setCurrentJob(job);
            setState(() {
              _currentStep += 1;
            });
          }
        }
      }
    } else if (_currentStep == 1) {
      debugger();
      var jobStep2State = _jobStep2Key.currentState;

      if (jobStep2State != null && jobStep2State.validateAndSave()) {
        var saveRequest = jobStep2State.getUpdatedJob();

        var job = await _jobProvider.update(saveRequest.id!, saveRequest);
        if (job != null) {
          _jobProvider.setCurrentJob(job);
          setState(() {
            _currentStep += 1;
          });
        }
      }
    } else {
      setState(() {
        isCompleted = true;
      });
    }
  }
}
