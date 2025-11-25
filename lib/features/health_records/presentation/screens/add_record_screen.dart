import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_mate_app/core/utils/date_formatter.dart';
import '../../data/models/health_record.dart';
import '../../presentation/providers/health_record_provider.dart';

class AddRecordScreen extends ConsumerStatefulWidget {
  const AddRecordScreen({super.key});

  @override
  ConsumerState<AddRecordScreen> createState() => _AddRecordScreenState();
}

class _AddRecordScreenState extends ConsumerState<AddRecordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _stepsController = TextEditingController();
  final _caloriesController = TextEditingController();
  final _waterController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  @override
  void dispose() {
    _stepsController.dispose();
    _caloriesController.dispose();
    _waterController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _saveRecord() async {
    if (_formKey.currentState!.validate()) {
      final record = HealthRecord(
        date: _selectedDate.toIso8601String(),
        steps: int.parse(_stepsController.text),
        calories: int.parse(_caloriesController.text),
        water: int.parse(_waterController.text),
      );

      try {
        await ref.read(healthRecordNotifierProvider.notifier).addRecord(record);
        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record added successfully!')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  String? _validateNumeric(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'Please enter $fieldName';
    }
    final num = int.tryParse(value);
    if (num == null) {
      return 'Please enter a valid number';
    }
    if (num < 0) {
      return 'Value cannot be negative';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Health Record'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Date Picker
              OutlinedButton.icon(
                onPressed: () => _selectDate(context),
                icon: const Icon(Icons.calendar_today),
                label: Text(
                  'Date: ${DateFormatter.formatDateDisplay(_selectedDate)}',
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 24),

              // Steps Field
              TextFormField(
                controller: _stepsController,
                decoration: const InputDecoration(
                  labelText: 'Steps',
                  hintText: 'Enter steps walked',
                  prefixIcon: Icon(Icons.directions_walk, color: Colors.green),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumeric(value, 'steps'),
              ),
              const SizedBox(height: 16),

              // Calories Field
              TextFormField(
                controller: _caloriesController,
                decoration: const InputDecoration(
                  labelText: 'Calories',
                  hintText: 'Enter calories burned',
                  prefixIcon: Icon(Icons.local_fire_department, color: Colors.red),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumeric(value, 'calories'),
              ),
              const SizedBox(height: 16),

              // Water Intake Field
              TextFormField(
                controller: _waterController,
                decoration: const InputDecoration(
                  labelText: 'Water Intake (ml)',
                  hintText: 'Enter water intake in ml',
                  prefixIcon: Icon(Icons.water_drop, color: Colors.blue),
                ),
                keyboardType: TextInputType.number,
                validator: (value) => _validateNumeric(value, 'water intake'),
              ),
              const SizedBox(height: 32),

              // Save Button
              FilledButton(
                onPressed: _saveRecord,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

