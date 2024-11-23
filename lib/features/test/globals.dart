import '../../models/lesson_model.dart';

final List<LessonModel> lessons = [
  // Вчера
  LessonModel(
    id: 1,
    subject: "Mathematics",
    group: "Group A",
    auditoryName: "Auditory 101",
    auditoryCapacity: 30,
    branchName: "Main Campus",
    branchAddress: "123 Main St",
    startTime: DateTime.now().subtract(Duration(days: 1, hours: 3)),
    endTime: DateTime.now().subtract(Duration(days: 1, hours: 1)),
    teacherName: "John",
    teacherSecondName: "Michael",
    teacherLastName: "Doe",
    task: "Homework on integrals",
    deadline: DateTime.now().add(Duration(days: 1)),
    type: 'Лекция'
  ),
  LessonModel(
    id: 2,
    subject: "Physics",
    group: "Group B",
    auditoryName: "Auditory 202",
    auditoryCapacity: 25,
    branchName: "West Campus",
    branchAddress: "456 West St",
    startTime: DateTime.now().subtract(Duration(days: 1, hours: 6)),
    endTime: DateTime.now().subtract(Duration(days: 1, hours: 4)),
    teacherName: "Jane",
    teacherSecondName: "Elizabeth",
    teacherLastName: "Smith",
    task: "Lab Report on optics",
    deadline: DateTime.now().add(Duration(days: 2)),
    type: 'Практика'
  ),

  // Сегодня
  LessonModel(
    id: 3,
    subject: "Chemistry",
    group: "Group C",
    auditoryName: "Auditory 303",
    auditoryCapacity: 20,
    branchName: "East Campus",
    branchAddress: "789 East St",
    startTime: DateTime.now().subtract(Duration(hours: 2)),
    endTime: DateTime.now().subtract(Duration(hours: 1)),
    teacherName: "Albert",
    teacherSecondName: "James",
    teacherLastName: "Brown",
    task: "Prepare for the periodic table quiz",
    deadline: DateTime.now().add(Duration(days: 3)),
      type: 'Лекция'
  ),
  LessonModel(
    id: 4,
    subject: "English Literature",
    group: "Group D",
    auditoryName: "Auditory 404",
    auditoryCapacity: 15,
    branchName: "North Campus",
    branchAddress: "234 North Ave",
    startTime: DateTime.now().add(Duration(hours: 1)),
    endTime: DateTime.now().add(Duration(hours: 3)),
    teacherName: "Emily",
    teacherSecondName: "Charlotte",
    teacherLastName: "Johnson",
    task: "Read chapters 4-6 of 'To Kill a Mockingbird'",
    deadline: DateTime.now().add(Duration(days: 2)),
      type: 'Лекция'
  ),
  LessonModel(
    id: 5,
    subject: "Biology",
    group: "Group E",
    auditoryName: "Auditory 505",
    auditoryCapacity: 18,
    branchName: "Main Campus",
    branchAddress: "123 Main St",
    startTime: DateTime.now().add(Duration(hours: 4)),
    endTime: DateTime.now().add(Duration(hours: 6)),
    teacherName: "Sophia",
    teacherSecondName: "Grace",
    teacherLastName: "Wilson",
    task: "Complete the plant cell diagram",
    deadline: DateTime.now().add(Duration(days: 3)),
      type: 'Практика'
  ),

  // Завтра
  LessonModel(
    id: 6,
    subject: "History",
    group: "Group F",
    auditoryName: "Auditory 606",
    auditoryCapacity: 40,
    branchName: "South Campus",
    branchAddress: "567 South Rd",
    startTime: DateTime.now().add(Duration(days: 1, hours: 2)),
    endTime: DateTime.now().add(Duration(days: 1, hours: 4)),
    teacherName: "Alexander",
    teacherSecondName: "Henry",
    teacherLastName: "Davis",
    task: "Prepare notes on World War II",
    deadline: DateTime.now().add(Duration(days: 5)),
      type: 'Практика'
  ),
  LessonModel(
    id: 7,
    subject: "Art",
    group: "Group G",
    auditoryName: "Auditory 707",
    auditoryCapacity: 10,
    branchName: "Main Campus",
    branchAddress: "123 Main St",
    startTime: DateTime.now().add(Duration(days: 1, hours: 5)),
    endTime: DateTime.now().add(Duration(days: 1, hours: 7)),
    teacherName: "Isabella",
    teacherSecondName: "Marie",
    teacherLastName: "Anderson",
    task: "Sketch a portrait",
    deadline: DateTime.now().add(Duration(days: 3)),
      type: 'Лекция'
  ),
  LessonModel(
    id: 8,
    subject: "Geography",
    group: "Group H",
    auditoryName: "Auditory 808",
    auditoryCapacity: 35,
    branchName: "West Campus",
    branchAddress: "456 West St",
    startTime: DateTime.now().add(Duration(days: 1, hours: 8)),
    endTime: DateTime.now().add(Duration(days: 1, hours: 10)),
    teacherName: "Daniel",
    teacherSecondName: "Robert",
    teacherLastName: "Martinez",
    task: "Map the continents",
    deadline: DateTime.now().add(Duration(days: 4)),
      type: 'Практика'
  ),
  LessonModel(
    id: 9,
    subject: "Programming",
    group: "Group I",
    auditoryName: "Auditory 909",
    auditoryCapacity: 50,
    branchName: "North Campus",
    branchAddress: "234 North Ave",
    startTime: DateTime.now().add(Duration(days: 1, hours: 12)),
    endTime: DateTime.now().add(Duration(days: 1, hours: 14)),
    teacherName: "Olivia",
    teacherSecondName: "Rose",
    teacherLastName: "Garcia",
    task: "Write a simple calculator app",
    deadline: DateTime.now().add(Duration(days: 6)),
      type: 'Лекция'
  ),
  LessonModel(
    id: 10,
    subject: "Physical Education",
    group: "Group J",
    auditoryName: "Gymnasium",
    auditoryCapacity: 100,
    branchName: "South Campus",
    branchAddress: "567 South Rd",
    startTime: DateTime.now().add(Duration(days: 1, hours: 15)),
    endTime: DateTime.now().add(Duration(days: 1, hours: 17)),
    teacherName: "Ethan",
    teacherSecondName: "Lucas",
    teacherLastName: "Harris",
    task: "Practice basketball drills",
    deadline: DateTime.now().add(Duration(days: 5)),
      type: 'Практика'
  ),
];
