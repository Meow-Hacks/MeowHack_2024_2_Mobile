import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'students_api.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({Key? key}) : super(key: key);

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late Future<Map<String, Map<String, List<Map<String, dynamic>>>>> _gradesFuture;
  String? selectedSubject;
  String? selectedGroup;
  final Map<int, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    _gradesFuture = _fetchGrades();
  }

  Future<Map<String, Map<String, List<Map<String, dynamic>>>>> _fetchGrades() async {
    final api = StudentsApi(context);
    return await api.fetchGrades();
  }

  Future<void> _submitMark(int studentId, int lessonId, int mark) async {
    final api = StudentsApi(context);

    try {
      await api.submitMark(studentId, lessonId, mark);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Оценка успешно отправлена')),
      );

      // Обновляем данные после успешной отправки
      setState(() {
        _gradesFuture = _fetchGrades();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка отправки оценки: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Оценки студентов'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, Map<String, List<Map<String, dynamic>>>>>(
        future: _gradesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Ошибка: ${snapshot.error}'),
            );
          }

          final grades = snapshot.data!;
          final subjects = grades.keys.toList();

          return Column(
            children: [
              // Выпадающий список предметов
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButton<String>(
                  value: selectedSubject,
                  hint: const Text('Выберите предмет'),
                  items: subjects.map((subject) {
                    return DropdownMenuItem(
                      value: subject,
                      child: Text(subject),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubject = value;
                      selectedGroup = null; // Сбрасываем выбранную группу
                    });
                  },
                ),
              ),

              if (selectedSubject != null) ...[
                // Выпадающий список групп
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButton<String>(
                    value: selectedGroup,
                    hint: const Text('Выберите группу'),
                    items: grades[selectedSubject]!.keys.map((group) {
                      return DropdownMenuItem(
                        value: group,
                        child: Text(group),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedGroup = value;
                      });
                    },
                  ),
                ),
              ],

              if (selectedGroup != null) ...[
                Expanded(
                  child: ListView.builder(
                    itemCount: grades[selectedSubject]![selectedGroup]!.length,
                    itemBuilder: (context, index) {
                      final student = grades[selectedSubject]![selectedGroup]![index];
                      print(student);
                      final controller = _controllers.putIfAbsent(
                        index,
                            () => TextEditingController(),
                      );

                      return Card(
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                student['FIO'],
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 8),
                              Wrap(
                                spacing: 8,
                                children: List<int>.from(student['marks'])
                                    .map((mark) {
                                  return Chip(label: Text(mark.toString()));
                                }).toList(),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: controller,
                                      decoration: const InputDecoration(
                                        labelText: 'Введите оценку',
                                      ),
                                      keyboardType: TextInputType.number,
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final mark = int.tryParse(controller.text);
                                      if (mark != null) {
                                        _submitMark(student['s_id'], 1, mark);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  'Введите корректное значение')),
                                        );
                                      }
                                    },
                                    child: const Text('Оценить'),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }
}
