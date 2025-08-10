import 'package:astro_iztro/app/modules/analysis/analysis_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnalysisView extends GetView<AnalysisController> {
  const AnalysisView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detailed Analysis')),
      body: const Center(
        child: Text('Analysis View - Coming Soon'),
      ),
    );
  }
}
