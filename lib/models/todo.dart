enum Priority { low, medium, high }

class Todo {
  final String id;
  String title;
  String description;
  bool done;
  DateTime createdAt;
  DateTime? dueDate;
  String category; // ← تأكد أنّك تعرف هذا الحقل
  Priority priority; // كذلك أولوية إن كنت تستخدمها

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
  factory Todo.fromJson(Map<String, dynamic> json) {
    // إذا مفتاح الفئة مفقود، اضبطه على 'عام'
    final cat = (json['category'] as String?) ?? 'عام';
    final prioStr = json['priority'] as String?;
    final prio = prioStr != null
        ? Priority.values.firstWhere(
            (p) => p.toString() == prioStr,
            orElse: () => Priority.medium,
          )
        : Priority.medium;

    return Todo(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      done: json['done'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      category: cat,
      priority: prio,
    );
  }

  // تحويل من كائن Todo إلى JSON
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'done': done,
    'createdAt': createdAt.toIso8601String(),
    'dueDate': dueDate?.toIso8601String(),
    'category': category,
    'priority': priority.toString(),
  };
}
