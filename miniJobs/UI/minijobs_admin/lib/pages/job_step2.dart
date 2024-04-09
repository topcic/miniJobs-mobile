import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/city.dart';
import 'package:minijobs_admin/models/job_type.dart';
import 'package:minijobs_admin/providers/city_provider.dart';
import 'package:minijobs_admin/providers/job_type_provider.dart';
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
            child:Container( 
              height: 400,
              child:JobForm()),
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
  List<String> jobSchedules = [
    'Morning Shift',
    'Afternoon Shift',
    'Evening Shift',
    'Night Shift',
  ];
  List<String> selectedJobSchedules =
      []; // List to store selected job schedules

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobTypeProvider = context.read<JobTypeProvider>();
  }

  @override
  void initState() {
    super.initState();
    getCities();
  }

  Future<void> getCities() async {
    cities = await _jobTypeProvider.get();
    setState(() {});
  }

 @override
Widget build(BuildContext context) {
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
                        child: Container(
                          child: FormBuilderTextField(
                            maxLines: 8,
                            keyboardType: TextInputType.multiline,
                            name: 'description',
                            decoration: InputDecoration(
                              labelText: "Opis",
                              hintText: "Enter your text here",
                              border: OutlineInputBorder(),
                            ),
                            validator: ((value) {
                              if (value == null || value.isEmpty) {
                                return "Opis je obavezno polje";
                              }
                              return null;
                            }),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                      CrossAxisAlignment.center,
                    ),
                    SizedBox(height: 10),
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
                                    .contains(textEditingValue.text
                                        .toLowerCase()))
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
                                              onTap: () =>
                                                  onSelected(option),
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
                                  return "Grad je obavezno polje";
                                } else {
                                  return null;
                                }
                              }),
                              name: 'city',
                              decoration: InputDecoration(
                                labelText: 'Grad',
                                labelStyle: TextStyle(fontSize: 14),
                              ),
                              onChanged: (_) => onEditingComplete(),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    rowMethod(
                      Expanded(
                        child: Wrap(
                          spacing: 8.0,
                          children: jobSchedules
                              .map(
                                (schedule) => Padding(
                                  padding: EdgeInsets.all(
                                      2), // Set padding of 2 pixels
                                  child: FilterChip(
                                    label: Text(
                                      schedule,
                                      style: TextStyle(
                                          fontSize:
                                              10), // Set the font size to 10 pixels
                                    ),
                                    selected: selectedJobSchedules
                                        .contains(schedule),
                                    onSelected: (bool selected) {
                                      setState(() {
                                        if (selected) {
                                          selectedJobSchedules
                                              .add(schedule);
                                        } else {
                                          selectedJobSchedules
                                              .remove(schedule);
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
                    SizedBox(height: 10),
                    rowMethod(
                      _textField('address', "Adresa"),
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
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    Map<String, dynamic> request =
                        Map.of(_formKey.currentState!.value);
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
  );
}
