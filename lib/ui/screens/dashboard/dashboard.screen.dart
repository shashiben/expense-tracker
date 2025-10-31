import 'package:expense_tracker/ui/screens/dashboard/dashboard.view_model.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DashboardScreen extends StackedView<DashboardViewModel> {
  const DashboardScreen({super.key});

  @override
  Widget builder(
    BuildContext context,
    DashboardViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  DashboardViewModel viewModelBuilder(BuildContext context) {
    return DashboardViewModel();
  }
}
