import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_mobile/enumerations/questions.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/proposed_answer.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/providers/job_type_provider.dart';
import 'package:minijobs_mobile/providers/proposed_answer_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class JobStep3 extends StatefulWidget {
  const JobStep3({super.key});

  @override
  State<JobStep3> createState() => _JobStep3State();
}

class _JobStep3State extends State<JobStep3> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isClickedBtnNext = false;
  String? paymentMethod;
  double? price;
  List<ProposedAnswer>? paymentOptions;
  Job? currentJob;
  int? paymentChoice;
  List<String> additionalPayments = [];
  List<ProposedAnswer>? additionalPaymentOptions;
  Map<int, List<int>>? answersToPaymentQuestions = {};
  late JobProvider _jobProvider = JobProvider();
  late ProposedAnswerProvider _proposedAnswerProvider =
      ProposedAnswerProvider();
  int? paymentChoiceQuestionId;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobProvider = Provider.of<JobProvider>(context);
    setState(() {
      currentJob = _jobProvider.getCurrentJob();
    });
  }

  @override
  void initState() {
    super.initState();
    getAdditionalPaymentOptions();
    getPaymentOptions();
  }

  Future<void> getPaymentOptions() async {
    paymentOptions = await _proposedAnswerProvider
        .getByQuestion(questionDescriptions[Questions.payment]!);
    print("paymentOptions $paymentOptions");
    setState(() {});
  }

  Future<void> getAdditionalPaymentOptions() async {
    additionalPaymentOptions = await _proposedAnswerProvider
        .getByQuestion(questionDescriptions[Questions.additionalPayment]!);
    setState(() {});
  }

  void saveAnswersToPaymentQuestions() {
    answersToPaymentQuestions = {};

    if (paymentChoice != null && paymentOptions != null) {
      setState(() {
        paymentChoiceQuestionId = paymentOptions!.first.questionId!;
      });
      int questionId = paymentOptions!.first.questionId!;
      answersToPaymentQuestions![questionId] = [paymentChoice!];
    }

    if (additionalPayments.isNotEmpty && additionalPaymentOptions != null) {
      int questionId = additionalPaymentOptions!.first.questionId!;
      answersToPaymentQuestions![questionId] =
          additionalPayments.map(int.parse).toList();
    }
  }

  // void _setInitialFormValues() {
  //   _formKey.currentState?.patchValue({
  //     'requiredEmployees': _job!.requiredEmployees.toString(),
  //     'jobTypeId': _job!.jobTypeId.toString(),
  //   });
  //   selectedJobSchedules =
  //       _job!.schedules?.map((schedule) => schedule.id!).toList();
  //   if (_job!.applicationsEndTo != null) {
  //     Duration difference = _job!.applicationsEndTo!.difference(_job!.created!);
  //     int days = difference.inDays;
  //     if (difference.inHours % 24 > 0) {
  //       days += 1;
  //     }

  //     applicationsEndTo = durationOptions
  //         .firstWhere((option) => option['days'] == days, orElse: () => {});
  //   }
  //   JobType? selectedJobType =
  //       _jobTypes?.firstWhere((jobType) => jobType.id == _job!.jobTypeId);
  //   if (selectedJobType != null) {
  //     _jobTypeController.text = selectedJobType.name!;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
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
              SizedBox(height: 20),
              rowMethod(Text("Izaberite način plaćanja")),
              SizedBox(height: 10),
              rowMethod(
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: paymentOptions != null &&
                            paymentOptions!.isNotEmpty
                        ? paymentOptions!
                            .map(
                              (option) => Padding(
                                padding: EdgeInsets.all(2),
                                child: FilterChip(
                                  label: Text(
                                    option.answer!, // Accessing option.answer
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  selected: paymentChoice == option.id,
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        paymentChoice = option.id!;
                                      } else {
                                        paymentChoice = null;
                                      }
                                    });
                                  },
                                ),
                              ),
                            )
                            .toList()
                        : [], // Return an empty list if paymentOptions is null or empty
                  ),
                ),
              ),
              if (paymentChoice != null &&
                  paymentOptions!
                          .firstWhere((option) =>
                              option.id.toString() == paymentChoice.toString())
                          .answer !=
                      "po dogovoru")
                FormBuilderTextField(
                    name: 'wage',
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Cijena',
                    ),
                    onChanged: (value) {
                      setState(() {
                        price = double.tryParse(value!);
                      });
                    },
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return "Cijena je obavezno polje";
                      }
                      return null;
                    })),
              if (isClickedBtnNext &&
                  (answersToPaymentQuestions == null ||
                      paymentChoiceQuestionId == null ||
                      answersToPaymentQuestions![paymentChoiceQuestionId!]!
                          .isEmpty))
                rowMethod(Text("Način plaćanja je obavezno polje",
                    style: TextStyle(color: Colors.red[800], fontSize: 12))),
              SizedBox(height: 20),
              rowMethod(Text("Plaćate li")),
              SizedBox(height: 10),
              rowMethod(
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: additionalPaymentOptions != null
                        ? additionalPaymentOptions!
                            .map(
                              (option) => Padding(
                                padding: EdgeInsets.all(2),
                                child: FilterChip(
                                  label: Text(
                                    option.answer ?? '',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  selected: additionalPayments
                                      .contains(option.id.toString()),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        additionalPayments
                                            .add(option.id!.toString());
                                      } else {
                                        additionalPayments
                                            .remove(option.id.toString());
                                      }
                                    });
                                  },
                                ),
                              ),
                            )
                            .toList()
                        : [],
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
          Text(label, style: TextStyle(fontSize: 14)),
          SizedBox(width: 8),
          Flexible(
            child: FormBuilderTextField(
              name: name,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "$label je obavezno polje";
                } else {
                  return null;
                }
              },
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

  validateAndSave() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      final Map<String, dynamic>? formValues = _formKey.currentState!.value;
      saveAnswersToPaymentQuestions();
      print(formValues);
      print(answersToPaymentQuestions);
    }
  }
}
