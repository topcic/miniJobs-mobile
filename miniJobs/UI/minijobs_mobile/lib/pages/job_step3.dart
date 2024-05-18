import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_mobile/enumerations/questions.dart';
import 'package:minijobs_mobile/providers/proposed_answer_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';
import '../models/proposed_answer.dart';

class JobStep3Page extends StatelessWidget {
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
                    'Plaćanje posla',
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
  bool isClickedBtnNext = false;
  String? paymentMethod;
  double? price;
  List<ProposedAnswer>? paymentOptions;

  String? paymentChoice;
  List<String> additionalPayments = [];
  List<ProposedAnswer>? additionalPaymentOptions;
  late ProposedAnswerProvider _proposedAnswerProvider =
      ProposedAnswerProvider();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _proposedAnswerProvider = context.read<ProposedAnswerProvider>();
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
                                            option
                                                .answer!, // Accessing option.answer
                                            style: TextStyle(fontSize: 10),
                                          ),
                                          selected: paymentChoice ==
                                              option.id.toString(),
                                          onSelected: (bool selected) {
                                            setState(() {
                                              if (selected) {
                                                paymentChoice =
                                                    option.id!.toString();
                                              } else {
                                                paymentChoice = "";
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
                                      option.id.toString() ==
                                      paymentChoice.toString())
                                  .answer !=
                              "po dogovoru")
                        FormBuilderTextField(
                            name: 'wage"',
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
                                                additionalPayments.remove(
                                                    option.id.toString());
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
                       Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _formKey.currentState?.save();
                        if (_formKey.currentState!.validate()) {
                          final Map<String, dynamic>? formValues =
                              _formKey.currentState!.value;
                       //   widget.onNextPressed();
                        }
                      },
                      child: Text('Dalje'),
                    ),
                  ],
                ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
