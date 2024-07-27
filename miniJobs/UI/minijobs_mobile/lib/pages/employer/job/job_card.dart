import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/pages/employer/job/steps/job_preview.dart';
import 'package:minijobs_mobile/pages/employer/job/job_modal.dart';
import 'package:minijobs_mobile/providers/job_provider.dart';
import 'package:provider/provider.dart';

class JobCard extends StatefulWidget {
  final Job job;
  const JobCard({super.key,required this.job});

  @override
  State<JobCard> createState() => _JobCardState();
}

class _JobCardState extends State<JobCard> {
late JobProvider jobProvider;
Job job=new Job();

@override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    jobProvider=context.read<JobProvider>();
    job=widget.job;
  }
  getJob(int id) async{
    job= await jobProvider.get(widget.job.id!);
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return  Card(
  margin: const EdgeInsets.all(10.0),
  color: Colors.blue[50],
  child: Container(
    alignment: Alignment.center,
    padding: const EdgeInsets.all(10.0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          job.name!,
          textAlign: TextAlign.center, // Poravnanje teksta na sredinu
        ),
        const SizedBox(height: 10), // Prostor između tekstova i ikona
         Row(
          mainAxisAlignment: MainAxisAlignment.center, // Poravnanje u sredini
          children: [
            Icon(Icons.location_on), // Ikona za lokaciju
            SizedBox(width: 10),
            Text(job.city?.name ??''),
          ],
        ),
        const SizedBox(height: 10), // Prostor između ikona i cijene
        Row(
          mainAxisAlignment: MainAxisAlignment.center, // Poravnanje u sredini
          children: [
            const Icon(Icons.money_sharp),
            const SizedBox(width: 10),
            Text(job.wage!>0 ?job.wage.toString(): 'po dogovoru'),
          ],
        ),
        const SizedBox(height: 10), // Prostor između cijene i gumba
         ElevatedButton(
          onPressed: ()async {
          await   getJob(job.id!);
            // Show dialog with job details
           showDialog(
      context: context,
      builder: (BuildContext context) {
        return  JobModal(
          // Pass job details to the modal constructor
          job: job!,
          role: GetStorage().read('role')
          // poslodavac: job.employerFullName!,
          // opstina: job.city?.name ??'',
          // adresa: job.streetAddressAndNumber!,
          // opis: job.description!,
          // posaoTip: job.jobType?.name??'',
          // cijena: job.wage.toString() ?? 'po dogovoru',
          // nacinPlacanja: job.paymentQuestion?.answer??'',
          // rasporedOdgovori:job.schedules?.map((option) => option.answer).join(', ') ?? '',
          // dodatnoPlacanje: job.additionalPaymentOptions?.map((option) => option.answer).join(', ') ?? null,
          // brojRadnika: job.numberOfApplications.toString()??'',
          // deadline: job.created!.add(Duration(days: job.applicationsDuration!)),
          // status: job.status!,
        );
      },
    );
          },
          child: const Text('Pogledaj'),
        ),
      ],
    ),
  ),
);
  }
}