class LessonModel {
  final int id;
  final String subject;
  final String group;
  final String auditoryName;
  final int auditoryCapacity;
  final String branchName;
  final String branchAddress;
  final DateTime startTime;
  final DateTime endTime;
  final String teacherName;
  final String teacherSecondName;
  final String teacherLastName;
  final String? task; // Сделано необязательным
  final DateTime? deadline; // Сделано необязательным
  final String type;

  LessonModel({
    required this.id,
    required this.subject,
    required this.group,
    required this.auditoryName,
    required this.auditoryCapacity,
    required this.branchName,
    required this.branchAddress,
    required this.startTime,
    required this.endTime,
    required this.teacherName,
    required this.teacherSecondName,
    required this.teacherLastName,
    this.task, // Обновлено
    this.deadline, // Обновлено
    required this.type,
  });

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    return LessonModel(
      id: json['id'],
      subject: json['subject'],
      group: json['group'],
      auditoryName: json['auditory_name'],
      auditoryCapacity: json['auditory_capacity'],
      branchName: json['branch_name'],
      branchAddress: json['branch_address'],
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      teacherName: json['teacher_name'],
      teacherSecondName: json['teacher_secondname'],
      teacherLastName: json['teacher_lastname'],
      task: json['task'], // Будет null, если отсутствует
      deadline: json['deadline'] != null ? DateTime.parse(json['deadline']) : null, // Обработано
      type: json['type_of_lesson'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'subject': subject,
      'group': group,
      'auditory_name': auditoryName,
      'auditory_capacity': auditoryCapacity,
      'branch_name': branchName,
      'branch_address': branchAddress,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'teacher_name': teacherName,
      'teacher_secondname': teacherSecondName,
      'teacher_lastname': teacherLastName,
      'task': task, // Сохраняется null, если отсутствует
      'deadline': deadline?.toIso8601String(), // Сохраняется null, если отсутствует
      'type': type,
    };
  }
}
