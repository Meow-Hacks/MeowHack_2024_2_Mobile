import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../di/global_data_provider.dart';

class GradeScreen extends StatefulWidget {
  const GradeScreen({Key? key}) : super(key: key);

  @override
  State<GradeScreen> createState() => _GradeScreenState();
}

class _GradeScreenState extends State<GradeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final globalData = Provider.of<GlobalDataProvider>(context);

    // Получение данных из провайдера
    final grades = globalData.grades;
    final gpa = globalData.gpa;
    final percentile = globalData.percentile;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Успеваемость'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: globalData.isLoading
            ? const Center(child: CircularProgressIndicator()) // Показ загрузки
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display GPA and Percentile
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _InfoBox(
                  label: 'GPA',
                  value: gpa.toStringAsFixed(2),
                  theme: theme,
                ),
                _InfoBox(
                  label: 'Percentile',
                  value: '${percentile.toStringAsFixed(2)}%',
                  theme: theme,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Display Grades
            grades.isEmpty
                ? const Center(
              child: Text(
                'No grades available.',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: grades.keys.length,
                itemBuilder: (context, index) {
                  final subject = grades.keys.elementAt(index);
                  final subjectGrades = grades[subject]!;

                  return _GradeItem(
                    subject: subject,
                    grades: subjectGrades,
                    theme: theme,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _InfoBox({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(label, style: theme.textTheme.labelMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _GradeItem extends StatefulWidget {
  final String subject;
  final List<int> grades;
  final ThemeData theme;

  const _GradeItem({
    required this.subject,
    required this.grades,
    required this.theme,
  });

  @override
  State<_GradeItem> createState() => _GradeItemState();
}

class _GradeItemState extends State<_GradeItem> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _heightAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _getColorForGrade(int grade) {
    switch (grade) {
      case 5:
        return Colors.green;
      case 4:
        return Colors.yellow;
      case 3:
        return Colors.orange;
      case 2:
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final avg = (widget.grades.reduce((a, b) => a + b) / widget.grades.length).toDouble();
    final avgColor = _getColorForGrade(avg.round());

    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
          _isExpanded ? _controller.forward() : _controller.reverse();
        });
      },
      child: AnimatedBuilder(
        animation: _heightAnimation,
        builder: (context, child) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: widget.theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: avgColor, width: 2),
              boxShadow: [
                BoxShadow(
                  color: widget.theme.shadowColor.withOpacity(0.1),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.subject,
                      style: widget.theme.textTheme.titleMedium,
                    ),
                    Text(
                      'Avg: ${avg.toStringAsFixed(2)}',
                      style: widget.theme.textTheme.labelLarge?.copyWith(color: avgColor),
                    ),
                  ],
                ),
                SizeTransition(
                  sizeFactor: _heightAnimation,
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: widget.grades
                            .map((grade) => Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: _getColorForGrade(grade).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            grade.toString(),
                            style: widget.theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: widget.theme.brightness == Brightness.dark
                                  ? Colors.white // Белый цвет для тёмной темы
                                  : Colors.black, // Чёрный цвет для светлой темы
                            ),
                          ),
                        ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
