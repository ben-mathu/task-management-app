import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jenga_planner/widgets/custom_button_widget.dart';

enum TaskCompletionState { completed, inProgress, pending }

enum TaskPriority { urgent, high, normal, low }

enum TaskSortType { priority, completion, date }

class Filters extends StatelessWidget {
  final List<Object> filters;
  final Function(List<Object> newFilters) onFiltersChanged;

  const Filters({
    super.key,
    required this.onFiltersChanged,
    required this.filters,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      width: double.infinity,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Filters',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10.0),
            Text('Completion', style: TextStyle(fontWeight: FontWeight.bold)),
            getChips(
              HashMap.fromIterable(
                TaskCompletionState.values,
                key: (v) => v,
                value: (v) => _contains(v),
              ),
            ),
            Text('Priority', style: TextStyle(fontWeight: FontWeight.bold)),
            getChips(
              HashMap.fromIterable(
                TaskPriority.values,
                key: (v) => v,
                value: (v) => _contains(v),
              ),
            ),
            Text('Sort by', style: TextStyle(fontWeight: FontWeight.bold)),
            getChips(
              HashMap.fromIterable(
                TaskSortType.values,
                key: (v) => v,
                value: (v) => _contains(v),
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                onPressed: () => Navigator.pop(context),
                text: 'Done',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getChips(HashMap<Object, bool> values) {
    List<Widget> chips = [];
    for (final entry in values.entries) {
      final filter = _getFilter(entry.key);

      chips.add(
        FilterChip(
          selected: entry.value,
          onSelected: (bool selected) {
            List<Object> modifiedFilters = filters.toList();
            if (entry.key is TaskSortType) {
              modifiedFilters.removeWhere((element) {
                if (element is TaskSortType) {
                  return TaskSortType.values.contains(element);
                }
                return false;
              });
            }

            onFiltersChanged(modifiedFilters..add(filter.$2));
          },
          label: Text(filter.$1.toUpperCase(), style: TextStyle(fontSize: 12.0)),
        ),
      );
    }

    return Wrap(spacing: 10.0, children: chips);
  }

  bool _contains(v) {
    return filters.contains(v);
  }

  (String, Object) _getFilter(Object key) {
    String item;
    if (key is TaskSortType) {
      item = key.name;
    } else if (key is TaskPriority) {
      item = key.name;
    } else if (key is TaskCompletionState) {
      item = key.name;
    } else {
      throw Exception('Unknown filter type');
    }

    return (item, key);
  }
}
