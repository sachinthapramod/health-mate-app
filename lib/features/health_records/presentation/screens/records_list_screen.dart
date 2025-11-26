import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:health_mate_app/core/utils/date_formatter.dart';
import 'package:health_mate_app/core/theme/app_theme.dart';
import '../../presentation/providers/health_record_provider.dart';
import 'update_record_screen.dart';

class RecordsListScreen extends ConsumerStatefulWidget {
  const RecordsListScreen({super.key});

  @override
  ConsumerState<RecordsListScreen> createState() => _RecordsListScreenState();
}

class _RecordsListScreenState extends ConsumerState<RecordsListScreen> {
  final _searchController = TextEditingController();
  DateTime? _selectedFilterDate;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _selectFilterDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedFilterDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _selectedFilterDate = picked;
      });
      // Use date at midnight to ensure proper matching
      final dateString = DateTime(picked.year, picked.month, picked.day).toIso8601String();
      ref.read(healthRecordNotifierProvider.notifier).searchByDate(dateString);
    }
  }

  void _clearFilter() {
    setState(() {
      _selectedFilterDate = null;
    });
    ref.read(healthRecordNotifierProvider.notifier).loadRecords();
  }

  Future<void> _deleteRecord(int id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Record'),
        content: const Text('Are you sure you want to delete this record?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await ref.read(healthRecordNotifierProvider.notifier).deleteRecord(id);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Record deleted successfully!')),
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

  @override
  Widget build(BuildContext context) {
    final recordsAsync = ref.watch(healthRecordNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Health Records'),
        actions: [
          if (_selectedFilterDate != null)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearFilter,
              tooltip: 'Clear filter',
            ),
        ],
      ),
      body: Column(
        children: [
          // Search/Filter Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _selectFilterDate(context),
                    icon: const Icon(Icons.filter_list),
                    label: Text(
                      _selectedFilterDate != null
                          ? DateFormatter.formatDateDisplay(_selectedFilterDate!)
                          : 'Filter by Date',
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Records List
          Expanded(
            child: recordsAsync.when(
              data: (records) {
                if (records.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No records found',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _selectedFilterDate != null
                              ? 'Try a different date'
                              : 'Add your first health record!',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: records.length,
                  itemBuilder: (context, index) {
                    final record = records[index];
                    return Dismissible(
                      key: Key(record.id.toString()),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(right: 20),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteRecord(record.id!);
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            DateFormatter.formatDateDisplay(
                              DateFormatter.parseDate(record.date),
                            ),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 16,
                                runSpacing: 8,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.directions_walk,
                                          size: 16, color: AppTheme.stepsColor),
                                      const SizedBox(width: 4),
                                      Text('${record.steps} steps'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.local_fire_department,
                                          size: 16, color: AppTheme.caloriesColor),
                                      const SizedBox(width: 4),
                                      Text('${record.calories} kcal'),
                                    ],
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.water_drop,
                                          size: 16, color: AppTheme.waterColor),
                                      const SizedBox(width: 4),
                                      Text('${record.water} ml'),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => UpdateRecordScreen(
                                    record: record,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline,
                        size: 64, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading records',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: Theme.of(context).textTheme.bodySmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () {
                        ref
                            .read(healthRecordNotifierProvider.notifier)
                            .loadRecords();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

