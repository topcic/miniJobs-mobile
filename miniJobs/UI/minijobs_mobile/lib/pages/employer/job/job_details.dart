
import 'package:flutter/material.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_preview.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_step_1.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_step_2.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_step_3.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

import '../../../models/job/job_step1_request.dart';

class JobDetails extends StatefulWidget {
  final int jobId;

  const JobDetails({super.key, required this.jobId});

  @override
  _JobDetailsState createState() => _JobDetailsState();
}

class _JobDetailsState extends State<JobDetails> {
  int _currentStep = 0;
  bool isCompleted = false;
  Job _job = Job();
  late JobProvider _jobProvider;
  final GlobalKey<JobStep1State> _jobStep1Key = GlobalKey<JobStep1State>();
  late Function() _validateAndSaveStep2Callback;
  late Function() _validateAndSaveStep3Callback;
  bool isCalledCanAccessStep = false;
  int requestedStep = 0;

  @override
  void initState() {
    super.initState();
    _jobProvider = Provider.of<JobProvider>(context, listen: false);
    _initializeJob(widget.jobId);
  }

  @override
  void didUpdateWidget(JobDetails oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.jobId != oldWidget.jobId) {
      _initializeJob(widget.jobId);
    }
  }

  void _initializeJob(int jobId) async {
    // Reset the state to default before loading new job data
    setState(() {
      _currentStep = 0;
      isCompleted = false;
      _job = Job(); // Clear old job data
      isCalledCanAccessStep = false;
      requestedStep = 0;
    });

    if (jobId != 0) {
      final job = await _jobProvider.get(jobId); // Fetch new job data
      _jobProvider.setCurrentJob(job);
      if (job.status != JobStatus.Kreiran) {
        setState(() {
          _currentStep = 3;
        });
      }
      if (job.status == JobStatus.Zavrsen ||
          job.status == JobStatus.AplikacijeZavrsene) {
        setState(() {
          isCompleted = true;
        });
      }
      setState(() {
        _job = job; // Update state with fetched job data
      });
    } else {
      _jobProvider.setCurrentJob(null);
    }
  }

  bool isJobCompleted() {
    return _job.status == JobStatus.Zavrsen;
  }


  Future<bool> canAccessStep(int step) async {
    if (step == 0) {
      return true;
    } else if (step == 1) {
      var jobStep1State = _jobStep1Key.currentState;
      return jobStep1State != null && jobStep1State.validateAndSave();
    } else if (step == 2) {
      var jobStep1State = _jobStep1Key.currentState;
      if (jobStep1State != null && jobStep1State.validateAndSave()) {
        _job = jobStep1State.getUpdatedJob();
        return _validateAndSaveStep2Callback();
      }
      return false;
    } else if (step == 3) {
      var jobStep1State = _jobStep1Key.currentState;
      if (jobStep1State != null && jobStep1State.validateAndSave()) {
        _job = jobStep1State.getUpdatedJob();

        _validateAndSaveStep2Callback();
        setState(() {
          isCalledCanAccessStep = true;
        });
        _validateAndSaveStep3Callback();
        return true;
      }
      return false;
    }
    return false;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobProvider = Provider.of<JobProvider>(context, listen: false);
    _initializeJob(widget.jobId);
  }

  void _onNextButton(bool isValid,int id,[dynamic request]) async {
    if (isValid) {
      if (!isCalledCanAccessStep) {
        Job? job;
        if (_currentStep == 1) {
          job = await _jobProvider.updateStep2(id, request);
        } else if (_currentStep == 2) {
          job = await _jobProvider.updateStep3(id, request);
        }
        _jobProvider.setCurrentJob(job!);
        setState(() {
          _currentStep += 1;
        });
      } else {
        setState(() {
          isCalledCanAccessStep = false;
          _currentStep = requestedStep;
        });
      }
    }
  }

  void updateJobForStep1(Job currentJob) {
    setState(() {
      _job.name = currentJob.name;
      _job.description = currentJob.description;
      _job.cityId = currentJob.cityId;
      _job.streetAddressAndNumber = currentJob.streetAddressAndNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalji posla'),
      ),
      body: isCompleted
          ? buildCompleted()
          : isJobCompleted()
              ? const JobPreview() // Show only job preview if the job is completed
              : Stepper(
                  type: StepperType.horizontal,
                  steps: getSteps(),
                  currentStep: _currentStep,
                  onStepContinue: () async {
                    setState(() {
                      isCalledCanAccessStep = false;
                    });
                    await nextStep();
                  },
                  onStepTapped: (step) async {
                    setState(() {
                      requestedStep = step;
                      isCalledCanAccessStep = true;
                    });
                    if (await canAccessStep(step)) {
                      setState(() {
                        isCalledCanAccessStep = false;
                        _currentStep = requestedStep;
                      });
                    }
                  },
                  onStepCancel: _currentStep == 0
                      ? null
                      : () {
                          setState(() {
                            _currentStep -= 1;
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
                              ),
                            ),
                          const SizedBox(width: 10),
                          if (_job.status == JobStatus.Kreiran && isLastStep)
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('Objavi posao'),
                              ),
                            ),
                          if (_job.id == 0 ||
                              _job.id == null ||
                              ((_job.status == JobStatus.Kreiran ||
                                      _job.status == JobStatus.Aktivan) &&
                                  !isLastStep))
                            Expanded(
                              child: ElevatedButton(
                                onPressed: details.onStepContinue,
                                child: const Text('Dalje'),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
    );
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
          state: _currentStep == 1
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
          state: _currentStep == 2
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
        ),
      ];

  Widget buildCompleted() {
    return const JobPreview(); // Display JobPreview when completed
  }

  nextStep() async {
    if (_currentStep == 0 && !isCalledCanAccessStep) {
      var jobStep1State = _jobStep1Key.currentState;

      if (jobStep1State != null &&
          jobStep1State.validateAndSave() &&
          !isCalledCanAccessStep) {
        var currentJob = jobStep1State.getUpdatedJob();
        if (_job.id == null || _job.id == 0) {
          var job = await _jobProvider.insert(currentJob);
          setState(() {
            if (job != null) {
              _job = job;
            }
            _jobProvider.setCurrentJob(job);
            _currentStep += 1;
          });
        } else {
          updateJobForStep1(currentJob);
          var saveRequest = JobStep1Request(_job.name,_job.description,_job.streetAddressAndNumber,_job.cityId);
          var job = await _jobProvider.updateStep1(_job.id!, saveRequest);
          _jobProvider.setCurrentJob(job);
          setState(() {
            _job = job!;
            _currentStep += 1;
          });
        }
      }
    } else if (_currentStep == 1 && !isCalledCanAccessStep) {
      _validateAndSaveStep2Callback();
    } else if (_currentStep == 2 && !isCalledCanAccessStep) {
      _validateAndSaveStep3Callback();
    } else if (_currentStep == 3 && !isCalledCanAccessStep) {
      var job = await _jobProvider.activate(_job.id!, JobStatus.Aktivan);
      _jobProvider.setCurrentJob(job);
      setState(() {
        isCompleted = true;
      });
    }
  }
}
