
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/enumerations/questions.dart';
import 'package:minijobs_admin/models/job_type.dart';
import 'package:minijobs_admin/models/proposed_answer.dart';
import 'package:minijobs_admin/providers/job_type_provider.dart';
import 'package:minijobs_admin/providers/proposed_answer_provider.dart';
import 'package:minijobs_admin/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class JobStep2Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 200, // Customize height here
              color: Colors.blue[100],
            ),
          ),
          Positioned(
            top: 50,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Detalji posla',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Container(height: 400, child: JobForm()),
          ),
        ],
      ),
    );
  }
}

class JobForm extends StatefulWidget {
  @override
  _JobFormState createState() => _JobFormState();
}

class _JobFormState extends State<JobForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<JobType>? cities;
  late JobTypeProvider _jobTypeProvider = JobTypeProvider();
   late ProposedAnswerProvider _proposedAnswerProvider =
      ProposedAnswerProvider();
  List<ProposedAnswer>? jobSchedules ;
  String selectedOption = '';
  List<String> durationOptions = [
    '1-3 dana',
    '3 do 7 dana',
    '1 do 2 sedmice',
    '2 do 4 sedmice',
  ];
   bool showAllSchedules = false;
  List<String>? selectedJobSchedules = []; 
  String? applicationsEndTo;
 bool isClickedBtnNext = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobTypeProvider = context.read<JobTypeProvider>();
     _proposedAnswerProvider = context.read<ProposedAnswerProvider>();
  }

  @override
  void initState() {
    super.initState();
    getCities();
    getScheduleOptions();
  }
Future<void> getScheduleOptions() async {
    jobSchedules = await _proposedAnswerProvider
        .getByQuestion(questionDescriptions[Questions.workingHours]!);
    setState(() {});
  }
  Future<void> getCities() async {
    cities = await _jobTypeProvider.get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
     List<ProposedAnswer>? displayedSchedules =
        showAllSchedules ? jobSchedules : jobSchedules?.take(6).toList();
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
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
                            optionsBuilder:
                                (TextEditingValue textEditingValue) {
                              if (textEditingValue.text.isEmpty) {
                                return const Iterable<String>.empty();
                              }
                              return cities!
                                  .where((element) => element.name!
                                      .toLowerCase()
                                      .contains(
                                          textEditingValue.text.toLowerCase()))
                                  .map((e) => e.name!);
                            },
                            onSelected: (String selection) {
                              // Handle the selected option
                            },
                            optionsViewBuilder: (context,
                                Function(String) onSelected,
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
                                                        fontSize: 12)),
                                                onTap: () => onSelected(option),
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                            fieldViewBuilder: (context, controller, focusNode,
                                onEditingComplete) {
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
                                name: 'jobType',
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
      children: displayedSchedules?.map(
        (schedule) => Padding(
          padding: EdgeInsets.all(2),
          child: FilterChip(
            label: Text(
              schedule.answer ?? '',
              style: TextStyle(fontSize: 10),
            ),
            selected: selectedJobSchedules!.contains(schedule.id.toString()),
            onSelected: (bool selected) {
              setState(() {
                if (selected) {
                  selectedJobSchedules!.add(schedule.id.toString());
                } else {
                  selectedJobSchedules!.remove(schedule.id.toString());
                }
              });
            },
          ),
        ),
      ).toList() ??
          [],
    ),
  ),
),
if (!showAllSchedules)
  ElevatedButton(
    onPressed: () {
      setState(() {
        showAllSchedules = true;
      });
    },
    child: Text("Show More"),
  ),
if (showAllSchedules)
  ElevatedButton(
    onPressed: () {
      setState(() {
        showAllSchedules = false;
      });
    },
    child: Text("Show Less"),
  ),
                     if (isClickedBtnNext && (selectedJobSchedules == null || selectedJobSchedules!.isEmpty))
                      rowMethod(Text("Rspored posla je obavezno polje",style: TextStyle(color: Colors.red[800],fontSize: 12)) ),
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
                                        option,
                                        style: TextStyle(fontSize: 10),
                                      ),
                                      selected: applicationsEndTo == option,
                                      onSelected: (bool selected) {
                                        setState(() {
                                          if (selected) {
                                            applicationsEndTo = option;
                                          } else {
                                            applicationsEndTo = '';
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
                      if (isClickedBtnNext && (applicationsEndTo == null || applicationsEndTo!.isEmpty))
                      rowMethod(Text("Ovo je obavezno polje",style: TextStyle(color: Colors.red[800],fontSize: 12),) ),
                      SizedBox(height: 20),
                        rowMethod(
                        Expanded(
                          child: FormBuilderTextField(
                              keyboardType: TextInputType.number,
                              name: 'requiredEmployees',
                              decoration: InputDecoration(
                                label: Text(
                                  "Koliko Vam je potrebno radnika za ovaj posao?",
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                              validator: ((value) {
                                if (value == null || value.isEmpty) {
                                  return "Broj radnika je obavezno polje";
                                }
                                return null;
                              })),
                        ),
                        CrossAxisAlignment.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
    print("before $isClickedBtnNext");
    isClickedBtnNext = true;
    print(isClickedBtnNext);
  });
                    _formKey.currentState?.save();
                    if (_formKey.currentState!.validate()) {
                      Map<String, dynamic> request =
                          Map.of(_formKey.currentState!.value);
                          print(request);
                    }
                  },
                  child: Text('Dalje'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
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
