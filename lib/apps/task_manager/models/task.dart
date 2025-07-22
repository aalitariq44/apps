enum TaskPriority {
  low,
  medium,
  high,
  urgent,
}

enum TaskStatus {
  pending,
  inProgress,
  completed,
  cancelled,
}

class Task {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final TaskPriority priority;
  final TaskStatus status;
  final DateTime createdAt;
  final DateTime? updatedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.priority,
    this.status = TaskStatus.pending,
    required this.createdAt,
    this.updatedAt,
  });

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    TaskPriority? priority,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get priorityText {
    switch (priority) {
      case TaskPriority.low:
        return 'Low';
      case TaskPriority.medium:
        return 'Medium';
      case TaskPriority.high:
        return 'High';
      case TaskPriority.urgent:
        return 'Urgent';
    }
  }

  String get statusText {
    switch (status) {
      case TaskStatus.pending:
        return 'Pending';
      case TaskStatus.inProgress:
        return 'In Progress';
      case TaskStatus.completed:
        return 'Completed';
      case TaskStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Dummy data for demonstration
  static List<Task> getDummyTasks() {
    final now = DateTime.now();
    return [
      Task(
        id: '1',
        title: 'Complete Flutter Project',
        description: 'Finish the task manager application with all required screens and functionality',
        dueDate: now.add(const Duration(days: 3)),
        priority: TaskPriority.high,
        status: TaskStatus.inProgress,
        createdAt: now.subtract(const Duration(days: 2)),
      ),
      Task(
        id: '2',
        title: 'Review Code',
        description: 'Review the code for the e-commerce application and provide feedback',
        dueDate: now.add(const Duration(days: 1)),
        priority: TaskPriority.medium,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Task(
        id: '3',
        title: 'Update Documentation',
        description: 'Update the project documentation with latest changes and API references',
        dueDate: now.add(const Duration(days: 5)),
        priority: TaskPriority.low,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 12)),
      ),
      Task(
        id: '4',
        title: 'Team Meeting',
        description: 'Attend the weekly team meeting to discuss project progress and next steps',
        dueDate: now.add(const Duration(hours: 2)),
        priority: TaskPriority.urgent,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 6)),
      ),
      Task(
        id: '5',
        title: 'Testing Phase',
        description: 'Conduct comprehensive testing of all application features',
        dueDate: now.add(const Duration(days: 7)),
        priority: TaskPriority.high,
        status: TaskStatus.pending,
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
    ];
  }
}
