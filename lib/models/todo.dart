enum Priority { low, medium, high }

class Todo {
  String id, title, description, category;
  bool done;
  DateTime createdAt;
  DateTime? dueDate;
  Priority priority;

  Todo({
    String? id,
    required this.title,
    required this.description,
    this.done = false,
    DateTime? createdAt,
    this.dueDate,
    this.category = 'عام',
    this.priority = Priority.low,
  }) : id = id ?? DateTime.now().microsecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  // تحويل من JSON إلى كائن Todo
  factory Todo.fromJson(Map<String, dynamic> json) => Todo(
    id: json['id'] as String,
    title: json['title'] as String,
    description: json['description'] as String,
    done: json['done'] as bool? ?? false,
    createdAt: DateTime.parse(json['createdAt'] as String),
    category: json['category'] as String? ?? 'عام',
    priority: Priority.values.firstWhere(
      (p) => p.toString() == json['priority'],
      orElse: () => Priority.low,
    ),
    dueDate: json['dueDate'] != null
        ? DateTime.parse(json['dueDate'] as String)
        : null,
  );

  // تحويل من كائن Todo إلى JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'done': done,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    category: category,
    'priority': priority.toString(),
  };
}
