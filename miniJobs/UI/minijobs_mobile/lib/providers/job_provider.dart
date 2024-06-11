import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dio/dio.dart';
import 'package:minijobs_mobile/enumerations/job_statuses.dart';
import 'package:minijobs_mobile/models/job/job.dart';
import 'package:minijobs_mobile/providers/base_provider.dart';

class JobProvider extends BaseProvider<Job> {
  List<Job> _jobs = [];
  Job? _currentJob;
  JobProvider(): super("jobs");
    @override
  Job fromJson(data) {
    return Job.fromJson(data);
  }
 Future<void> setCurrentJob(Job job) async {

    _currentJob = job;
    notifyListeners();
  }

  
    Job? getCurrentJob() {
    return _currentJob;
  }
   Future<Job> activate(int id, JobStatus status) async {
    try {
   
       var dio = Dio();
        var url = baseUrl + "jobs/activate/"+id.toString(); 
   dio.options.headers['Content-Type'] = 'application/json';
    
    // Send the request with the status serialized as JSON
    var response = await dio.put(url, data: status.index.toString());
     Job responseData = Job.fromJson(response.data);
     if(responseData!=null){
        Fluttertoast.showToast(
    msg: "Uspješno postavljen posao",
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
  );
     }
    return responseData;

    } catch (err) {
      throw Exception(err.toString());
    }
  }
}