
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_mobile/enumerations/questions.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/models/job/job_save_request.dart';
import 'package:minijobs_mobile/models/job/job_schedule_info.dart';
import 'package:minijobs_mobile/models/proposed_answer.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/providers/proposed_answer_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';

class JobStep3 extends StatefulWidget {
  final Function(bool, JobSaveRequest) onNextButton;
  final Function(Function()) setValidateAndSaveCallback;
  const JobStep3({
    super.key,
    required this.onNextButton,
    required this.setValidateAndSaveCallback,
  });

  @override
  State<JobStep3> createState() => _JobStep3State();
}

class _JobStep3State extends State<JobStep3> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool isClickedBtnNext = false;
  //int? wage;
  List<ProposedAnswer>? paymentOptions;
  List<ProposedAnswer>? additionalPaymentOptions;
  Job? _job;
  int? paymentChoice;
  List<int> selectedAdditionalPayments = [];
  Map<int, List<int>>? answersToPaymentQuestions = {};
  late JobProvider _jobProvider = JobProvider();
  late final ProposedAnswerProvider _proposedAnswerProvider =
      ProposedAnswerProvider();
  int? paymentChoiceQuestionId;
  JobSaveRequest? _jobSaveRequest;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _jobProvider = Provider.of<JobProvider>(context);
    setState(() {
      _job = _jobProvider.getCurrentJob();
      _setInitialFormValues();
    });
    widget.setValidateAndSaveCallback(validateAndSave);
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

    if (selectedAdditionalPayments.isNotEmpty &&
        additionalPaymentOptions != null) {
      int questionId = additionalPaymentOptions!.first.questionId!;
      answersToPaymentQuestions![questionId] = selectedAdditionalPayments;
    }
  }

  void _setInitialFormValues() {
    if (_job != null) {
  if (_job!.additionalPaymentOptions != null) {
    selectedAdditionalPayments =
        _job!.additionalPaymentOptions!.map((option) => option.id!).toList();
  }
  if (_job!.paymentQuestion != null) {
    paymentChoice = _job!.paymentQuestion!.id!;
  }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 1,
            offset: const Offset(0, 3),
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
              const SizedBox(height: 20),
              rowMethod(const Text("Izaberite način plaćanja")),
              const SizedBox(height: 10),
              rowMethod(
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: paymentOptions != null &&
                            paymentOptions!.isNotEmpty
                        ? paymentOptions!
                            .map(
                              (option) => Padding(
                                padding: const EdgeInsets.all(2),
                                child: FilterChip(
                                  label: Text(
                                    option.answer!, // Accessing option.answer
                                    style: const TextStyle(fontSize: 10),
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
                    initialValue: _job?.wage?.toString(),
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Cijena',
                    ),
                    // onChanged: (value) {
                    //   setState(() {
                    //     wage = int.tryParse(value!);
                    //   });
                    // },
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
              const SizedBox(height: 20),
              rowMethod(const Text("Plaćate li")),
              const SizedBox(height: 10),
              rowMethod(
                Expanded(
                  child: Wrap(
                    spacing: 8.0,
                    children: additionalPaymentOptions != null
                        ? additionalPaymentOptions!
                            .map(
                              (option) => Padding(
                                padding: const EdgeInsets.all(2),
                                child: FilterChip(
                                  label: Text(
                                    option.answer ?? '',
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  selected: selectedAdditionalPayments
                                      .contains(option.id),
                                  onSelected: (bool selected) {
                                    setState(() {
                                      if (selected) {
                                        selectedAdditionalPayments
                                            .add(option.id!);
                                      } else {
                                        selectedAdditionalPayments
                                            .remove(option.id);
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

  validateAndSave() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {

      final Map<String, dynamic> formValues = _formKey.currentState!.value;
      saveAnswersToPaymentQuestions();
      var jobScheduleInfo = JobScheduleInfo(
          questionValues[Questions.workingHours]!,
          _job?.schedules?.map((e) => e.id!).toList() ?? []);

      var saveRequest = JobSaveRequest(
        _job!.id!,
        _job!.name,
        _job!.description,
        _job!.streetAddressAndNumber,
        _job!.cityId,
        _job?.status?.index,
        _job?.jobTypeId,
        _job?.requiredEmployees!,
        jobScheduleInfo,
        answersToPaymentQuestions,
       formValues['wage']!=null? int.tryParse(formValues['wage']) : 0,
        _job?.applicationsDuration!,
      );

      setState(() {
        _jobSaveRequest = saveRequest;
      });
      widget.onNextButton(true, _jobSaveRequest!);
    } else {
      widget.onNextButton(false, _jobSaveRequest!);
    }
  }

  JobSaveRequest getUpdatedJob() {
    return _jobSaveRequest!;
  }
}

final Map<Questions, int> questionValues = {
  Questions.workingHours: 1,
  Questions.payment: 2,
  Questions.additionalPayment: 3,
};
