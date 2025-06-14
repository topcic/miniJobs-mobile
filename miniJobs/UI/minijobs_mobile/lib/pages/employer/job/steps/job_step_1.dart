import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_quill/quill_delta.dart' as quill show Delta;
import 'package:minijobs_mobile/models/city.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/city_provider.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:minijobs_mobile/utils/util_widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;

class JobStep1 extends StatefulWidget {
  const JobStep1({super.key});

  @override
  JobStep1State createState() => JobStep1State();
}

class JobStep1State extends State<JobStep1> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<City>? cities;
  late CityProvider _cityProvider;
  late JobProvider _jobProvider;
  Job? _job;
  bool isLoading = true;

  // Initialize _quillController with a default value to avoid late initialization error
  final quill.QuillController _quillController = quill.QuillController(
    document: quill.Document(),
    selection: const TextSelection.collapsed(offset: 0),
  );
  final FocusNode _editorFocusNode = FocusNode();
  final ScrollController _editorScrollController = ScrollController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _cityProvider = context.read<CityProvider>();
    _jobProvider = context.read<JobProvider>();

    if (cities == null) {
      getCities();
    } else {
      _job = _jobProvider.getCurrentJob();
      _setInitialFormValues();
    }
  }

  Future<void> getCities() async {
    try {
      cities = await _cityProvider.getAll();
      if (mounted) {
        setState(() {
          isLoading = false;
          _job = _jobProvider.getCurrentJob();
          _setInitialFormValues();
        });
      }
    } catch (e) {
      log('Error fetching cities: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  void _setInitialFormValues() {
    if (_job != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.patchValue({
          'name': _job!.name,
          'cityId': _job!.cityId?.toString(),
          'streetAddressAndNumber': _job!.streetAddressAndNumber,
        });

        // Set the initial description in the Quill editor if it exists
        if (_job!.description != null && _job!.description!.isNotEmpty) {
          try {
            // Decode the JSON string and load it as a Delta
            final delta = quill.Delta.fromJson(jsonDecode(_job!.description!));
            _quillController.document = quill.Document.fromDelta(delta);
          } catch (e) {
            log('Error setting Quill description: $e');
            // Fallback: Treat as plain text if JSON parsing fails
            final delta = quill.Delta()..insert(_job!.description! + '\n');
            _quillController.document = quill.Document.fromDelta(delta);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _formKey.currentState?.dispose();
    _quillController.dispose();
    _editorFocusNode.dispose();
    _editorScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : Container(
      child: FormBuilder(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              rowMethod(
                _textField('name', "Naziv posla"),
                CrossAxisAlignment.center,
              ),
              const SizedBox(height: 20),
              // Rich Text Editor for Description
              rowMethod(
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey[400]!, // Match typical InputDecoration border color
                        width: 1.0,
                      ),
                      borderRadius: BorderRadius.circular(4), // Match typical field border radius
                    ),
                    padding: const EdgeInsets.all(8),
                  child: Column(

                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Toolbar for formatting options
                      quill.QuillSimpleToolbar(
                        controller: _quillController,
                        config: const quill.QuillSimpleToolbarConfig(
                          showAlignmentButtons: true,
                          showListBullets: true,
                          showListNumbers: true,
                          showBoldButton: true,
                          showItalicButton: true,
                          showUnderLineButton: true,
                          showLink: true,
                          showHeaderStyle: false,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Editor area
                      FormBuilderField<String>(
                        name: 'description',
                        validator: (value) {
                          final plainText = _quillController.document.toPlainText().trim();
                          if (plainText.isEmpty) return "Opis je obavezno polje";
                          return null;
                        },
                        builder: (field) => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            quill.QuillSimpleToolbar(controller: _quillController, config: const quill.QuillSimpleToolbarConfig(
                              showAlignmentButtons: true,
                              showListBullets: true,
                              showListNumbers: true,
                              showBoldButton: true,
                              showItalicButton: true,
                              showUnderLineButton: true,
                              showLink: true,
                              showHeaderStyle: false,
                            )),
                            const SizedBox(height: 8),
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                border: Border.all(color: field.hasError ? Colors.red : Colors.grey),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: quill.QuillEditor(
                                controller: _quillController,
                                focusNode: _editorFocusNode,
                                scrollController: _editorScrollController,
                                config: const quill.QuillEditorConfig(
                                  placeholder: 'Unesite opis ovdje',
                                  padding: EdgeInsets.all(8),
                                  expands: false,
                                ),
                              ),
                            ),
                            if (field.hasError)
                              Padding(
                                padding: const EdgeInsets.only(top: 4.0, left: 8),
                                child: Text(field.errorText ?? '',
                                    style: const TextStyle(color: Colors.red, fontSize: 12)),
                              ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                ),
                CrossAxisAlignment.center,
              ),
              const SizedBox(height: 20),
              rowMethod(
                Expanded(
                  child: FormBuilderDropdown<String>(
                    name: 'cityId',
                    validator: (value) {
                      if (value == null) {
                        return "Grad je obavezno polje";
                      }
                      return null;
                    },
                    decoration: const InputDecoration(
                      labelText: "Grad",
                      labelStyle: TextStyle(fontSize: 14),
                    ),
                    items: cities?.map((g) {
                      return DropdownMenuItem(
                        value: g.id.toString(),
                        child: Text(
                          g.name ?? '',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    }).toList() ??
                        [],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              rowMethod(
                _textField('streetAddressAndNumber', "Adresa"),
                CrossAxisAlignment.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded _textField(String name, String label) {
    return Expanded(
      child: FormBuilderTextField(
        name: name,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label je obavezno polje";
          }
          return null;
        },
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(fontSize: 14),
        ),
      ),
    );
  }

  bool validateAndSave() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      final formData = Map<String, dynamic>.from(_formKey.currentState!.value);

      // Get the description from the Quill editor as Delta JSON
      final descriptionJson = jsonEncode(_quillController.document.toDelta().toJson());

      formData['description'] = descriptionJson;
      formData['cityId'] = int.tryParse(formData['cityId']);

      setState(() {
        var job = Job.fromJson(formData);
        if (_job == null) {
          _job = job;
        } else {
          _job!.name = job.name;
          _job!.description = job.description;
          _job!.cityId = job.cityId;
          _job!.streetAddressAndNumber = job.streetAddressAndNumber;
        }
      });
      return true;
    }
    return false;
  }

  bool isValidForm() {
    _formKey.currentState?.save();
    if (_formKey.currentState!.validate()) {
      final description = _quillController.document.toPlainText().trim();
      if (description.isEmpty) {
        return false;
      }
      return true;
    }
    return false;
  }

  Job getUpdatedJob() {
    return _job!;
  }
}