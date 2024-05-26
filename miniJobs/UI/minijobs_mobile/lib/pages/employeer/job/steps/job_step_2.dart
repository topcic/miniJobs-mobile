import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_mobile/enumerations/questions.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/job/job_save_request.dart';
import 'package:minijobs_mobile/models/job/job_schedule_info.dart';
import 'package:minijobs_mobile/models/job_type.dart';
import 'package:minijobs_mobile/models/proposed_answer.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/providers/job_type_provider.dart';
import 'package:minijobs_mobile/providers/proposed_answer_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class JobStep2 extends StatefulWidget {
  const JobStep2({super.key});

  @override
  State<JobStep2> createState() => JobStep2State();
}

class JobStep2State extends State<JobStep2> {
  final _formKey = GlobalKey<FormBuilderState>();
  Job? _job;
  JobSaveRequest? _jobSaveRequest;
  List<ProposedAnswer>? _jobSchedules;
  List<JobType>? _jobTypes;
  String selectedOption = '';
  List<Map<String, dynamic>> durationOptions = [
    {'label': '1-3 dana', 'days': 3},
    {'label': '3 do 7 dana', 'days': 7},
    {'label': '1 do 2 sedmice', 'days': 14},
    {'label': '2 do 4 sedmice', 'days': 28},
  ];
  bool showAllSchedules = false;
  List<int>? selectedJobSchedules = [];
  Map<String, dynamic>? applicationsEndTo;
  bool isClickedBtnNext = false;
  late JobTypeProvider _jobTypeProvider = JobTypeProvider();
  late ProposedAnswerProvider _proposedAnswerProvider =
      ProposedAnswerProvider();
  late JobProvider _jobProvider = JobProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobTypeProvider = context.read<JobTypeProvider>();
    _proposedAnswerProvider = context.read<ProposedAnswerProvider>();
    _jobProvider = Provider.of<JobProvider>(context);

    setState(() {
      _job = _jobProvider.getCurrentJob();
    });
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
              //    Text(currentJob!.name!),
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
                      // Find the corresponding ID based on the selected name
                      int selectedId = _jobTypes!
                          .firstWhere((element) => element.name == selection)
                          .id!;
                      // Handle the selected option (name), while saving the corresponding ID
                      _formKey.currentState?.fields['jobTypeId']
                          ?.didChange(selectedId);
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
                                            style: TextStyle(
                                                fontSize: 12)), // Display name
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
                        style: TextStyle(fontSize: 12),
                        validator: ((value) {
                          if (value == null || value.isEmpty) {
                            return "Tip posla je obavezno polje";
                          } else {
                            return null;
                          }
                        }),
                        name: 'jobTypeId',
                        decoration: InputDecoration(
                          labelText: 'Tip posla',
                          labelStyle: TextStyle(fontSize: 14),
                        ),
                        onChanged: (_) => onEditingComplete(),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 20),
              rowMethod(Text("Raspored posla")),
              SizedBox(height: 10),
              rowMethod(
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: displayedSchedules
                            ?.map(
                              (schedule) => Padding(
                                padding: EdgeInsets.all(2),
                                child: FilterChip(
                                  label: Text(
                                    schedule.answer ?? '',
                                    style: TextStyle(fontSize: 10),
                                  ),
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
              SizedBox(
                height: 10,
              ),
              if (!showAllSchedules)
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
                        icon: Text("više", style: TextStyle(fontSize: 12)),
                        label: Icon(Icons.keyboard_arrow_down, size: 20),
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
                        icon: Text("manje", style: TextStyle(fontSize: 12)),
                        label: Icon(Icons.keyboard_arrow_up, size: 20))
                  ],
                ),
              if (isClickedBtnNext &&
                  (selectedJobSchedules == null ||
                      selectedJobSchedules!.isEmpty))
                rowMethod(Text("Rspored posla je obavezno polje",
                    style: TextStyle(color: Colors.red[800], fontSize: 12))),
              SizedBox(height: 20),
              rowMethod(Text("Koliko brzo želite da pronađete?")),
              SizedBox(height: 10),
              rowMethod(
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: durationOptions
                        .map(
                          (option) => Padding(
                            padding: EdgeInsets.all(2),
                            child: FilterChip(
                              label: Text(
                                option['label'],
                                style: TextStyle(fontSize: 10),
                              ),
                              selected: applicationsEndTo == option,
                              onSelected: (bool selected) {
                                setState(() {
                                  if (selected) {
                                    applicationsEndTo = option;
                                  } else {
                                    applicationsEndTo = null;
                                  }
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
                rowMethod(
                  Text(
                    "Ovo je obavezno polje",
                    style: TextStyle(color: Colors.red[800], fontSize: 12),
                  ),
                ),
              SizedBox(height: 20),
              rowMethod(
                Expanded(
                  child: FormBuilderTextField(
                    keyboardType: TextInputType.number,
                    name: 'requiredEmployees',
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      label: Text(
                        "Koliko Vam je potrebno radnika za ovaj posao?",
                        style: TextStyle(fontSize: 12),
                      ),
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _textField(String name, String label) {
    return Expanded(
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
            ),
          ),
          SizedBox(width: 8), // Add spacing between label and text field
          Flexible(
            child: FormBuilderTextField(
              name: name,
              validator: ((value) {
                if (value == null || value.isEmpty) {
                  return "$label je obavezno polje";
                } else {
                  return null;
                }
              }),
              style: TextStyle(fontSize: 12),
              decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool validateAndSave() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic>? formValues = _formKey.currentState!.value;
      var selectedJobTypeName = formValues!['jobTypeId'];
      var selectedJobType = _jobTypes!
          .firstWhere((jobType) => jobType.name == selectedJobTypeName);

      var jobScheduleInfo =
          JobScheduleInfo(_jobSchedules![0].questionId, selectedJobSchedules);
      var saveRequest = JobSaveRequest(
          _job!.id!,
          _job!.name,
          _job!.description,
          _job!.streetAddressAndNumber,
          _job!.cityId,
          0,
          selectedJobType.id,
          int.tryParse(formValues!['requiredEmployees']),
          jobScheduleInfo,
          null,
          null,
          DateTime.now().add(Duration(days: applicationsEndTo!['days']!)));

      setState(() {
        _jobSaveRequest = saveRequest;
      });
      return true;
    }
    return false;
  }

  JobSaveRequest getUpdatedJob() {
    return _jobSaveRequest!;
  }
}
