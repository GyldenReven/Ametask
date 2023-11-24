import 'package:ametask/models/tasklists_model.dart';
import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  const DetailPage(this.tasklist, {super.key});

  final Tasklist tasklist;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [Container(color: Colors.red,)],
        ),
      )
    );
  }
}

//listvue interessant