class Task {
  final int? id;
  final String name;

  Task({this.id, required this.name});

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(id: map['id'], name: map['name']);
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name};
  }
}
