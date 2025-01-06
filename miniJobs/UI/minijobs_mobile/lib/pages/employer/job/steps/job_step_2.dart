import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:minijobs_mobile/enumerations/questions.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/job/job_schedule_info.dart';
import 'package:minijobs_mobile/models/job_type.dart';
import 'package:minijobs_mobile/models/proposed_answer.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/providers/job_type_provider.dart';
import 'package:minijobs_mobile/providers/proposed_answer_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';
import '../../../../enumerations/job_statuses.dart';
import '../../../../models/job/job_step2.request.dart';

class JobStep2 extends StatefulWidget {
  final Function(bool,int, JobStep2Request) onNextButton;
  final Function(Function()) setValidateAndSaveCallback;

  const JobStep2({
    super.key,
    required this.onNextButton,
    required this.setValidateAndSaveCallback,
  });

  @override
  State<JobStep2> createState() => JobStep2State();
}

class JobStep2State extends State<JobStep2> {
  final _formKey = GlobalKey<FormBuilderState>();
  Job? _job;
  JobStep2Request? _jobStep2Request;
  List<ProposedAnswer>? _jobSchedules;
  List<JobType>? _jobTypes;
  String selectedOption = '';
  List<Map<String, dynamic>> durationOptions = [
    {'label': '1-3 dana', 'days': 3},
    {'label': '3 do 7 dana', 'days': 7},
    {'label': '1 do 2 sedmice', 'days': 14},
    {'label': '2 do 4 sedmice', 'days': 28},
  ];
  final TextEditingController _daysController = TextEditingController();
  bool showAllSchedules = false;
  List<int>? selectedJobSchedules = [];
  Map<String, dynamic>? applicationsEndTo;
  bool isClickedBtnNext = false;
  late JobTypeProvider _jobTypeProvider = JobTypeProvider();
  late ProposedAnswerProvider _proposedAnswerProvider =
      ProposedAnswerProvider();
  late JobProvider _jobProvider = JobProvider();
  final TextEditingController _jobTypeController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobTypeProvider = context.read<JobTypeProvider>();
    _proposedAnswerProvider = context.read<ProposedAnswerProvider>();
    _jobProvider = Provider.of<JobProvider>(context);

    _job = _jobProvider.getCurrentJob();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_job != null) {
        _setInitialFormValues();
      }
    });
    widget.setValidateAndSaveCallback(validateAndSave);
  }

  @override
  void initState() {
    super.initState();
    getJobTypes();
    getScheduleOptions();
  }

  Future<void> getScheduleOptions() async {
    _jobSchedules = await _proposedAnswerProvider
        .getByQuestion(questionDescriptions[Questions.workingHours]!);
    setState(() {});
  }

  Future<void> getJobTypes() async {
    _jobTypes = await _jobTypeProvider.getAll();
    setState(() {});
  }

  void _setInitialFormValues() {
    _formKey.currentState?.patchValue({
      'requiredEmployees': _job?.requiredEmployees?.toString() ?? '',
      'jobType': _job?.jobType?.name ?? '',
    });

    selectedJobSchedules =
        _job?.schedules?.map((schedule) => schedule.id!).toList() ?? [];

    if (_job?.applicationsDuration != null) {
      applicationsEndTo = durationOptions.firstWhere(
        (option) => option['days'] == _job!.applicationsDuration,
        orElse: () => {},
      );
    }

    JobType? selectedJobType;
    if (_jobTypes != null && _job?.jobTypeId != null) {
      selectedJobType =
          _jobTypes!.firstWhere((jobType) => jobType.id == _job!.jobTypeId);
    }
    if (selectedJobType != null) {
      _jobTypeController.text = selectedJobType.name!;
    }
  }

  @override
  Widget build(BuildContext context) {
    List<ProposedAnswer>? displayedSchedules =
        showAllSchedules ? _jobSchedules : _jobSchedules?.take(6).toList();
    return Container(
      child: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              rowMethod(
                Expanded(
                  child: Autocomplete<String>(
                    optionsBuilder: (TextEditingValue textEditingValue) {
                      if (textEditingValue.text.isEmpty) {
                        return const Iterable<String>.empty();
                      }
                      return _jobTypes!
                          .where((element) => element.name!
                              .toLowerCase()
                              .contains(textEditingValue.text.toLowerCase()))
                          .map((e) => e.name!);
                    },
                    onSelected: (String selection) {
                      int selectedId = _jobTypes!
                          .firstWhere((element) => element.name == selection)
                          .id!;
                      _formKey.currentState?.fields['jobTypeId']
                          ?.didChange(selectedId.toString());
                      _jobTypeController.text = selection;
                    },
                    optionsViewBuilder: (context, Function(String) onSelected,
                        Iterable<String> options) {
                      return Align(
                        alignment: Alignment.topLeft,
                        child: Material(
                          elevation: 4,
                          child: SizedBox(
                            height: 200,
                            width: 200,
                            child: ListView(
                              children: options
                                  .map((option) => ListTile(
                                        title: Text(option,
                                            style:
                                                const TextStyle(fontSize: 12)),
                                        onTap: () => onSelected(option),
                                      ))
                                  .toList(),
                            ),
                          ),
                        ),
                      );
                    },
                    fieldViewBuilder:
                        (context, controller, focusNode, onEditingComplete) {
                      return FormBuilderTextField(
                        controller: controller,
                        focusNode: focusNode,
                        style: const TextStyle(fontSize: 12),
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Tip posla je obavezno polje";
                          } else {
                            return null;
                          }
                        }),
                        name: 'jobType',
                        decoration: const InputDecoration(
                          labelText: 'Tip posla',
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        onChanged: (_) => onEditingComplete(),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              rowMethod(const Text("Raspored posla")),
              const SizedBox(height: 10),
              rowMethod(
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: displayedSchedules
                            ?.map(
                              (schedule) => Padding(
                                padding: const EdgeInsets.all(2),
                                child: FilterChip(
                                  label: Text(schedule.answer ?? '',
                                      style: const TextStyle(fontSize: 10)),
                                  selected: selectedJobSchedules!
                                      .contains(schedule.id),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedJobSchedules!.add(schedule.id!);
                                      } else {
                                        selectedJobSchedules!
                                            .remove(schedule.id);
                                      }
                                    });
                                  },
                                ),
                              ),
                            )
                            .toList() ??
                        [],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              if (!showAllSchedules)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          showAllSchedules = true;
                        });
                      },
                      icon: const Text("više", style: TextStyle(fontSize: 12)),
                      label: const Icon(Icons.keyboard_arrow_down, size: 20),
                    ),
                  ],
                ),
              if (showAllSchedules)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          showAllSchedules = false;
                        });
                      },
                      icon: const Text("manje", style: TextStyle(fontSize: 12)),
                      label: const Icon(Icons.keyboard_arrow_up, size: 20),
                    ),
                  ],
                ),
              if (isClickedBtnNext &&
                  (selectedJobSchedules == null ||
                      selectedJobSchedules!.isEmpty))
                rowMethod(Text("Raspored posla je obavezno polje",
                    style: TextStyle(color: Colors.red[800], fontSize: 12))),
              const SizedBox(height: 20),
              if (_job!.status == JobStatus.Aktivan) ...[
                Text(
                  'Aplikacije traju do: ${DateFormat('dd.MM.yyyy').format(_job!.applicationsStart!.add(Duration(days: _job!.applicationsDuration!)))}',
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 10),
                rowMethod(
                  Expanded(
                    child: FormBuilderTextField(
                      name: 'extendApplicationsDuration',
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        label: Text(
                          "Dodajte broj dana za produženje trajanja aplikacija",
                          style: TextStyle(fontSize: 12),
                        ),
                      ),
                      validator: (value) {
                        // Check if the field is empty
                        if (value != null && value.isNotEmpty) {
                          final parsedValue = int.tryParse(value);
                          // Validate only if the input is not null and is <= 0
                          if (parsedValue == null || parsedValue <= 0) {
                            return "Unesite validan broj dana";
                          }
                        }
                        return null; // No validation errors for empty fields
                      },
                    ),
                  ),
                ),
              ] else ...[
                rowMethod(const Text("Koliko brzo želite da pronađete?")),
                const SizedBox(height: 10),
                rowMethod(
                  Expanded(
                    child: Wrap(
                      spacing: 8.0,
                      children: durationOptions
                          .map(
                            (option) => Padding(
                              padding: const EdgeInsets.all(2),
                              child: FilterChip(
                                label: Text(option['label'],
                                    style: const TextStyle(fontSize: 10)),
                                selected: applicationsEndTo == option,
                                onSelected: (bool selected) {
                                  setState(() {
                                    applicationsEndTo =
                                        selected ? option : null;
                                  });
                                },
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
                if (isClickedBtnNext &&
                    (applicationsEndTo == null || applicationsEndTo!.isEmpty))
                  rowMethod(Text("Ovo je obavezno polje",
                      style: TextStyle(color: Colors.red[800], fontSize: 12))),
              ],
              const SizedBox(height: 20),
              rowMethod(
                Expanded(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.number,
                    name: 'requiredEmployees',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: const InputDecoration(
                      label: Text(
                          "Koliko Vam je potrebno radnika za ovaj posao?",
                          style: TextStyle(fontSize: 12)),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Broj radnika je obavezno polje";
                      } else if (int.tryParse(value) == null ||
                          int.tryParse(value)! <= 0) {
                        return "Broj radnika mora biti veći od 0";
                      }
                      return null;
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  validateAndSave() {
    _formKey.currentState?.save();
    setState(() {
      isClickedBtnNext = true;
    });
    if (_formKey.currentState!.validate() &&
        selectedJobSchedules != null &&
        selectedJobSchedules!.isNotEmpty &&
        applicationsEndTo != null) {
      final Map<String, dynamic> formValues = _formKey.currentState!.value;
      var selectedJobTypeName = formValues['jobType'];
      var selectedJobType = _jobTypes!
          .firstWhere((jobType) => jobType.name == selectedJobTypeName);
      var jobScheduleInfo =
          JobScheduleInfo(_jobSchedules![0].questionId, selectedJobSchedules);
      var extendApplicationsDurationValue =
      formValues['extendApplicationsDuration'] != null
          ? int.tryParse(formValues['extendApplicationsDuration'].toString()) ?? 0
          : 0;

      var applicationsEndToDays = _job!.status == JobStatus.Aktivan
          ? _job!.applicationsDuration! + extendApplicationsDurationValue
          : applicationsEndTo!['days']!;
      var saveRequest = JobStep2Request(
        selectedJobType.id,
        int.tryParse(formValues['requiredEmployees']),
        jobScheduleInfo,
        applicationsEndToDays,
      );

      setState(() {
        _jobStep2Request = saveRequest;
      });
      widget.onNextButton(true,_job!.id!, _jobStep2Request!);
    } else {
      widget.onNextButton(false,_job!.id!, _jobStep2Request!);
    }
  }

  bool isValidForm() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate() &&
        selectedJobSchedules != null &&
        selectedJobSchedules!.isNotEmpty &&
        (_job!.status == JobStatus.Aktivan || applicationsEndTo != null)) {
      return true;
    } else {
      return false;
    }
  }
}
