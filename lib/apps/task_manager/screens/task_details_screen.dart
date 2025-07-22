import 'package:flutter/material.dart';
import '../models/task.dart';

class TaskDetailsScreen extends StatefulWidget {
  final Task task;
  final Function(Task) onTaskUpdated;
  final Function(String) onTaskDeleted;
  final VoidCallback onLanguageToggle;

  const TaskDetailsScreen({
    super.key,
    required this.task,
    required this.onTaskUpdated,
    required this.onTaskDeleted,
    required this.onLanguageToggle,
  });

  @override
  State<TaskDetailsScreen> createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutCubic,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Color _getPriorityColor() {
    switch (widget.task.priority) {
      case TaskPriority.low:
        return Colors.green;
      case TaskPriority.medium:
        return Colors.orange;
      case TaskPriority.high:
        return Colors.red;
      case TaskPriority.urgent:
        return Colors.purple;
    }
  }

  String _getPriorityText(bool isArabic) {
    switch (widget.task.priority) {
      case TaskPriority.low:
        return isArabic ? 'منخفضة' : 'Low';
      case TaskPriority.medium:
        return isArabic ? 'متوسطة' : 'Medium';
      case TaskPriority.high:
        return isArabic ? 'عالية' : 'High';
      case TaskPriority.urgent:
        return isArabic ? 'عاجلة' : 'Urgent';
    }
  }

  IconData _getStatusIcon() {
    switch (widget.task.status) {
      case TaskStatus.pending:
        return Icons.schedule;
      case TaskStatus.inProgress:
        return Icons.play_circle_outline;
      case TaskStatus.completed:
        return Icons.check_circle;
      case TaskStatus.cancelled:
        return Icons.cancel;
    }
  }

  Color _getStatusColor() {
    switch (widget.task.status) {
      case TaskStatus.pending:
        return Colors.grey;
      case TaskStatus.inProgress:
        return Colors.blue;
      case TaskStatus.completed:
        return Colors.green;
      case TaskStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusText(bool isArabic) {
    switch (widget.task.status) {
      case TaskStatus.pending:
        return isArabic ? 'في الانتظار' : 'Pending';
      case TaskStatus.inProgress:
        return isArabic ? 'قيد التنفيذ' : 'In Progress';
      case TaskStatus.completed:
        return isArabic ? 'مكتملة' : 'Completed';
      case TaskStatus.cancelled:
        return isArabic ? 'ملغية' : 'Cancelled';
    }
  }

  String _formatDateTime(DateTime dateTime, bool isArabic) {
    final months = isArabic 
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
           'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final month = months[dateTime.month - 1];
    final day = dateTime.day;
    final year = dateTime.year;
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    
    if (isArabic) {
      return '$day $month $year - $hour:$minute';
    } else {
      return '$month $day, $year - $hour:$minute';
    }
  }

  void _toggleTaskStatus() {
    TaskStatus newStatus;
    switch (widget.task.status) {
      case TaskStatus.pending:
        newStatus = TaskStatus.inProgress;
        break;
      case TaskStatus.inProgress:
        newStatus = TaskStatus.completed;
        break;
      case TaskStatus.completed:
        newStatus = TaskStatus.pending;
        break;
      case TaskStatus.cancelled:
        newStatus = TaskStatus.pending;
        break;
    }

    final updatedTask = widget.task.copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );

    widget.onTaskUpdated(updatedTask);
    setState(() {});
  }

  void _showDeleteDialog(bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'حذف المهمة' : 'Delete Task'),
        content: Text(
          isArabic 
              ? 'هل تريد حذف هذه المهمة نهائياً؟'
              : 'Are you sure you want to delete this task permanently?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onTaskDeleted(widget.task.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(isArabic ? 'حذف' : 'Delete'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final now = DateTime.now();
    final isOverdue = widget.task.dueDate.isBefore(now) && 
                     widget.task.status != TaskStatus.completed;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(
                isArabic ? Icons.arrow_forward : Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            actions: [
              IconButton(
                onPressed: widget.onLanguageToggle,
                icon: const Icon(Icons.language, color: Colors.white),
              ),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') {
                    Navigator.pushNamed(
                      context,
                      '/edit-task',
                      arguments: {'task': widget.task},
                    );
                  } else if (value == 'delete') {
                    _showDeleteDialog(isArabic);
                  }
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        const Icon(Icons.edit, size: 20),
                        const SizedBox(width: 8),
                        Text(isArabic ? 'تعديل' : 'Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        const Icon(Icons.delete, size: 20, color: Colors.red),
                        const SizedBox(width: 8),
                        Text(
                          isArabic ? 'حذف' : 'Delete',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isArabic ? 'تفاصيل المهمة' : 'Task Details',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF6C5CE7),
                      Color(0xFF74B9FF),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        _getStatusIcon(),
                        size: 60,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: Container(
                  margin: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Task status and priority badges
                      Row(
                        children: [
                          // Status badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getStatusColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _getStatusColor()),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _getStatusIcon(),
                                  size: 16,
                                  color: _getStatusColor(),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _getStatusText(isArabic),
                                  style: TextStyle(
                                    color: _getStatusColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Priority badge
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _getPriorityColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: _getPriorityColor()),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.flag,
                                  size: 16,
                                  color: _getPriorityColor(),
                                ),
                                const SizedBox(width: 6),
                                Text(
                                  _getPriorityText(isArabic),
                                  style: TextStyle(
                                    color: _getPriorityColor(),
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Task title
                      Text(
                        widget.task.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: widget.task.status == TaskStatus.completed 
                              ? Colors.grey 
                              : null,
                          decoration: widget.task.status == TaskStatus.completed 
                              ? TextDecoration.lineThrough 
                              : null,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Description section
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.description, color: Color(0xFF6C5CE7)),
                                  const SizedBox(width: 8),
                                  Text(
                                    isArabic ? 'الوصف' : 'Description',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                widget.task.description,
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  height: 1.6,
                                  color: Colors.grey[700],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // Date information section
                      Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              // Due date
                              Row(
                                children: [
                                  Icon(
                                    Icons.schedule,
                                    color: isOverdue ? Colors.red : const Color(0xFF6C5CE7),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    isArabic ? 'تاريخ الاستحقاق' : 'Due Date',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (isOverdue)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.red.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        isArabic ? 'متأخر' : 'Overdue',
                                        style: const TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                child: Text(
                                  _formatDateTime(widget.task.dueDate, isArabic),
                                  style: TextStyle(
                                    color: isOverdue ? Colors.red : Colors.grey[600],
                                    fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                                  ),
                                ),
                              ),
                              
                              const Divider(height: 24),
                              
                              // Created date
                              Row(
                                children: [
                                  const Icon(Icons.add_circle_outline, color: Color(0xFF6C5CE7)),
                                  const SizedBox(width: 8),
                                  Text(
                                    isArabic ? 'تاريخ الإنشاء' : 'Created',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Align(
                                alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                child: Text(
                                  _formatDateTime(widget.task.createdAt, isArabic),
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ),
                              
                              // Updated date (if available)
                              if (widget.task.updatedAt != null) ...[
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    const Icon(Icons.update, color: Color(0xFF6C5CE7)),
                                    const SizedBox(width: 8),
                                    Text(
                                      isArabic ? 'آخر تحديث' : 'Last Updated',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: isArabic ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Text(
                                    _formatDateTime(widget.task.updatedAt!, isArabic),
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Action buttons
                      Row(
                        children: [
                          // Edit button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () {
                                Navigator.pushNamed(
                                  context,
                                  '/edit-task',
                                  arguments: {'task': widget.task},
                                );
                              },
                              icon: const Icon(Icons.edit),
                              label: Text(isArabic ? 'تعديل' : 'Edit'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF6C5CE7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(width: 12),
                          
                          // Status toggle button
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _toggleTaskStatus,
                              icon: Icon(_getStatusIcon()),
                              label: Text(
                                widget.task.status == TaskStatus.completed
                                    ? (isArabic ? 'إعادة فتح' : 'Reopen')
                                    : widget.task.status == TaskStatus.pending
                                        ? (isArabic ? 'بدء العمل' : 'Start')
                                        : (isArabic ? 'إنهاء' : 'Complete'),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: _getStatusColor(),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Delete button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showDeleteDialog(isArabic),
                          icon: const Icon(Icons.delete),
                          label: Text(isArabic ? 'حذف المهمة' : 'Delete Task'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
