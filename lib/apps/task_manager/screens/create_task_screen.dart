import 'package:flutter/material.dart';
import '../models/task.dart';

class CreateTaskScreen extends StatefulWidget {
  final Function(Task) onTaskCreated;
  final VoidCallback onLanguageToggle;

  const CreateTaskScreen({
    super.key,
    required this.onTaskCreated,
    required this.onLanguageToggle,
  });

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = TimeOfDay.now();
  TaskPriority _selectedPriority = TaskPriority.medium;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
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
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال عنوان المهمة' : 'Please enter task title';
    }
    if (value.length < 3) {
      return isArabic ? 'العنوان قصير جداً' : 'Title is too short';
    }
    return null;
  }

  String? _validateDescription(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال وصف المهمة' : 'Please enter task description';
    }
    if (value.length < 10) {
      return isArabic ? 'الوصف قصير جداً' : 'Description is too short';
    }
    return null;
  }

  Future<void> _selectDate() async {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      locale: Locale(locale.languageCode),
      helpText: isArabic ? 'اختر التاريخ' : 'Select Date',
      cancelText: isArabic ? 'إلغاء' : 'Cancel',
      confirmText: isArabic ? 'موافق' : 'OK',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime() async {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      helpText: isArabic ? 'اختر الوقت' : 'Select Time',
      cancelText: isArabic ? 'إلغاء' : 'Cancel',
      confirmText: isArabic ? 'موافق' : 'OK',
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
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

  String _getPriorityText(TaskPriority priority, bool isArabic) {
    switch (priority) {
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

  String _formatDateTime(DateTime date, TimeOfDay time, bool isArabic) {
    final months = isArabic 
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
           'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    
    if (isArabic) {
      return '$day $month $year - $hour:$minute';
    } else {
      return '$month $day, $year - $hour:$minute';
    }
  }

  void _createTask() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final dueDateTime = DateTime(
        _selectedDate.year,
        _selectedDate.month,
        _selectedDate.day,
        _selectedTime.hour,
        _selectedTime.minute,
      );

      final newTask = Task(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: dueDateTime,
        priority: _selectedPriority,
        createdAt: DateTime.now(),
      );

      widget.onTaskCreated(newTask);

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

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
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isArabic ? 'إنشاء مهمة جديدة' : 'Create New Task',
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
                        Icons.add_task,
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
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20),
                        
                        // Title field
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
                                    const Icon(Icons.title, color: Color(0xFF6C5CE7)),
                                    const SizedBox(width: 8),
                                    Text(
                                      isArabic ? 'عنوان المهمة' : 'Task Title',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _titleController,
                                  validator: _validateTitle,
                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: isArabic 
                                        ? 'مثال: مراجعة التقرير الشهري'
                                        : 'e.g., Review monthly report',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Description field
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
                                      isArabic ? 'وصف المهمة' : 'Task Description',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                TextFormField(
                                  controller: _descriptionController,
                                  validator: _validateDescription,
                                  maxLines: 4,
                                  textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                  decoration: InputDecoration(
                                    hintText: isArabic 
                                        ? 'اكتب وصفاً مفصلاً للمهمة...'
                                        : 'Write a detailed description of the task...',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(color: Colors.grey[300]!),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Due date and time section
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
                                    const Icon(Icons.schedule, color: Color(0xFF6C5CE7)),
                                    const SizedBox(width: 8),
                                    Text(
                                      isArabic ? 'تاريخ ووقت الاستحقاق' : 'Due Date & Time',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                // Date and time display
                                Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF6C5CE7).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    _formatDateTime(_selectedDate, _selectedTime, isArabic),
                                    style: const TextStyle(
                                      color: Color(0xFF6C5CE7),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 12),
                                
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _selectDate,
                                        icon: const Icon(Icons.calendar_today),
                                        label: Text(isArabic ? 'اختر التاريخ' : 'Select Date'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[100],
                                          foregroundColor: Colors.grey[700],
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: ElevatedButton.icon(
                                        onPressed: _selectTime,
                                        icon: const Icon(Icons.access_time),
                                        label: Text(isArabic ? 'اختر الوقت' : 'Select Time'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.grey[100],
                                          foregroundColor: Colors.grey[700],
                                          elevation: 0,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 16),
                        
                        // Priority selection
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
                                    const Icon(Icons.flag, color: Color(0xFF6C5CE7)),
                                    const SizedBox(width: 8),
                                    Text(
                                      isArabic ? 'الأولوية' : 'Priority',
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: TaskPriority.values.map((priority) {
                                    final isSelected = _selectedPriority == priority;
                                    return FilterChip(
                                      label: Text(_getPriorityText(priority, isArabic)),
                                      selected: isSelected,
                                      onSelected: (selected) {
                                        setState(() {
                                          _selectedPriority = priority;
                                        });
                                      },
                                      backgroundColor: Colors.grey[100],
                                      selectedColor: _getPriorityColor(priority).withOpacity(0.2),
                                      checkmarkColor: _getPriorityColor(priority),
                                      labelStyle: TextStyle(
                                        color: isSelected 
                                            ? _getPriorityColor(priority) 
                                            : Colors.grey[600],
                                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 32),
                        
                        // Create button
                        SizedBox(
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _createTask,
                            icon: _isLoading 
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.add_task),
                            label: Text(
                              _isLoading 
                                  ? (isArabic ? 'جاري الإنشاء...' : 'Creating...')
                                  : (isArabic ? 'إنشاء المهمة' : 'Create Task'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF6C5CE7),
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 2,
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
          ),
        ],
      ),
    );
  }
}
