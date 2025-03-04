import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:minijobs_admin/models/country.dart';
import 'package:minijobs_admin/providers/country_provider.dart';
import 'package:provider/provider.dart';

import '../../models/job_type.dart';
import '../../providers/job_type_provider.dart';

class JobTypeForm extends StatefulWidget {
  final JobType? jobType;
  final Function({bool success}) onClose;

  const JobTypeForm({super.key, this.jobType, required this.onClose});

  @override
  _JobTypeFormState createState() => _JobTypeFormState();
}

class _JobTypeFormState extends State<JobTypeForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late JobTypeProvider jobTypeProvider;
  String? _nameError; // To store the custom error message for the name field

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    jobTypeProvider = context.read<JobTypeProvider>();

    if (widget.jobType != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.patchValue({
          'name': widget.jobType!.name,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.jobType == null ? 'Dodaj tip posla' : 'Uredi tip posla'),
      content: SizedBox(
        width: 400,
        child: FormBuilder(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FormBuilderTextField(
                  name: 'name',
                  decoration: InputDecoration(
                    labelText: 'Naziv',
                    labelStyle: const TextStyle(fontSize: 14),
                    border: const OutlineInputBorder(),
                    errorText: _nameError, // Display custom error message here
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Naziv je obavezno polje';
                    }
                    return null; // Default validation; custom error handled separately
                  },
                  style: const TextStyle(fontSize: 12),
                  onChanged: (_) {
                    // Clear custom error when user starts typing
                    if (_nameError != null) {
                      setState(() {
                        _nameError = null;
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => widget.onClose(success: false),
          // Close without saving
          child: const Text('Odustani'),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState?.saveAndValidate() ?? false) {
              final formData = _formKey.currentState!.value;
              try {
                JobType newJobType = JobType(
                  widget.jobType?.id ?? 0,
                  formData['name'],
                  widget.jobType?.isDeleted ?? false,
                );

                if (widget.jobType == null) {
                  var response = await jobTypeProvider.insert(newJobType);
                  if (response != null && response.id != null) {
                    widget.onClose(success: true); // Close with success
                  }
                } else {
                  var response = await jobTypeProvider.update(
                      widget.jobType!.id!, newJobType);
                  if (response != null && response.id != null) {
                    widget.onClose(success: true); // Close with success
                  }
                }
              } catch (e) {
                if (e is DioException && e.response != null) {
                  final responseData = e.response!.data;
                  if (responseData is Map<String, dynamic>) {
                    String? errorMessage;

                    // Extract first validation error dynamically
                    for (var entry in responseData.entries) {
                      if (entry.value is List && entry.value.isNotEmpty) {
                        errorMessage = entry.value.first; // Take the first error message
                        break;
                      }
                    }

                    if (errorMessage != null) {
                      setState(() {
                        _nameError = errorMessage;
                        _formKey.currentState?.fields['name']?.invalidate(_nameError!);
                      });
                      return;
                    }
                  }
                }


              }

            }
          },

          child: const Text('Spasi'),
        ),
      ],
    );
  }
}
