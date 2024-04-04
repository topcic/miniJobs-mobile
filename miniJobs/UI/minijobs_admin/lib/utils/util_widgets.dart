import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

void alertBox(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          ));
}

void alertBoxMoveBack(BuildContext context, String title, String content) {
  showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                     Navigator.pop(context);
                  },
                  child: const Text('Ok')),
            ],
          ));
}
InputDecoration decoration(String? labela, IconData? icon) {
  return InputDecoration(label: Text(labela ?? ''), icon: Icon(icon));
}
Row rowMethod(Widget item, [CrossAxisAlignment? crossAxisAlignment]) {
    return Row(
      crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.center,
      children: [item],
    );
  }

  Expanded textField(String name, String label) {
    return Expanded(
        child: FormBuilderTextField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "Obavezno polje";
        } else {
          return null;
        }
      },
      name: name,
      decoration: InputDecoration(label: Text(label)),
    ));
  }

  Expanded textFieldReadOnly(String name, String label) {
    return Expanded(
        child: FormBuilderTextField(
      readOnly: true,
      name: name,
      decoration: InputDecoration(label: Text(label)),
    ));
  }

Widget Spinner() {
  return SpinKitRing(
    color: Colors.blue,
    lineWidth: 4,
    size: 50, 
  );
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
        decoration: InputDecoration(
          label: Text(label),
        ),
      ),
    );
  }
// napomene
// za rabbit mq
//za povećanje minisdkversion