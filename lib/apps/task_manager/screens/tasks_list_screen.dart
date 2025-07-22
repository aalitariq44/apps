import 'package:flutter/material.dart';
import '../models/task.dart';
import '../models/user.dart';
import '../widgets/task_card.dart';

class TasksListScreen extends StatefulWidget {
  final List<Task> tasks;
  final User currentUser;
  final VoidCallback onLanguageToggle;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const TasksListScreen({
    super.key,
    required this.tasks,
    required this.currentUser,
    required this.onLanguageToggle,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<TasksListScreen> createState() => _TasksListScreenState();
}

class _TasksListScreenState extends State<TasksListScreen>
    with TickerProviderStateMixin {
  TaskStatus _selectedFilter = TaskStatus.pending;
  String _searchQuery = '';
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  List<Task> get _filteredTasks {
    return widget.tasks.where((task) {
      final matchesStatus = _selectedFilter == TaskStatus.pending 
          ? true 
          : task.status == _selectedFilter;
      final matchesSearch = _searchQuery.isEmpty ||
          task.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          task.description.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesStatus && matchesSearch;
    }).toList();
  }

  Widget _buildFilterChip(TaskStatus status, String label, String labelAr) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    final isSelected = _selectedFilter == status;

    return FilterChip(
      label: Text(isArabic ? labelAr : label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = status;
        });
      },
      backgroundColor: Colors.grey[100],
      selectedColor: const Color(0xFF6C5CE7).withOpacity(0.2),
      checkmarkColor: const Color(0xFF6C5CE7),
      labelStyle: TextStyle(
        color: isSelected ? const Color(0xFF6C5CE7) : Colors.grey[600],
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
      ),
    );
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
            leading: Builder(
              builder: (context) => IconButton(
                onPressed: () => Scaffold.of(context).openDrawer(),
                icon: const Icon(Icons.menu, color: Colors.white),
              ),
            ),
            actions: [
              IconButton(
                onPressed: widget.onLanguageToggle,
                icon: const Icon(Icons.language, color: Colors.white),
              ),
              IconButton(
                onPressed: widget.onThemeToggle,
                icon: Icon(
                  widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isArabic ? 'مدير المهام' : 'Task Manager',
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
                        Icons.task_alt,
                        size: 60,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isArabic ? 'إدارة مهامك بكفاءة' : 'Manage Your Tasks Efficiently',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
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
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Search Bar
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                        decoration: InputDecoration(
                          hintText: isArabic ? 'البحث في المهام...' : 'Search tasks...',
                          prefixIcon: const Icon(Icons.search, color: Color(0xFF6C5CE7)),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.all(16),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Filter Chips
                    Text(
                      isArabic ? 'تصفية حسب الحالة:' : 'Filter by Status:',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFilterChip(TaskStatus.pending, 'All', 'الكل'),
                        _buildFilterChip(TaskStatus.inProgress, 'In Progress', 'قيد التنفيذ'),
                        _buildFilterChip(TaskStatus.completed, 'Completed', 'مكتملة'),
                        _buildFilterChip(TaskStatus.cancelled, 'Cancelled', 'ملغية'),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Tasks Count
                    Row(
                      children: [
                        Text(
                          isArabic ? 'المهام:' : 'Tasks:',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF6C5CE7).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            '${_filteredTasks.length}',
                            style: const TextStyle(
                              color: Color(0xFF6C5CE7),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Tasks List
          _filteredTasks.isEmpty
              ? SliverToBoxAdapter(
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Container(
                      padding: const EdgeInsets.all(40),
                      child: Column(
                        children: [
                          Icon(
                            Icons.task_alt,
                            size: 80,
                            color: Colors.grey[300],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isArabic ? 'لا توجد مهام' : 'No tasks found',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[500],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isArabic 
                                ? 'ابدأ بإنشاء مهمة جديدة'
                                : 'Start by creating a new task',
                            style: TextStyle(color: Colors.grey[400]),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final task = _filteredTasks[index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: TaskCard(
                            task: task,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/task-details',
                                arguments: task,
                              );
                            },
                            index: index,
                          ),
                        );
                      },
                      childCount: _filteredTasks.length,
                    ),
                  ),
                ),
        ],
      ),
      
      // Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.pushNamed(context, '/create-task');
        },
        backgroundColor: const Color(0xFF6C5CE7),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: Text(isArabic ? 'مهمة جديدة' : 'New Task'),
      ),
      
      // Drawer
      drawer: _buildDrawer(context, isArabic),
    );
  }

  Widget _buildDrawer(BuildContext context, bool isArabic) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
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
            accountName: Text(
              widget.currentUser.name,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            accountEmail: Text(widget.currentUser.email),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: widget.currentUser.avatar != null
                  ? NetworkImage(widget.currentUser.avatar!)
                  : null,
              child: widget.currentUser.avatar == null
                  ? Text(
                      widget.currentUser.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6C5CE7),
                      ),
                    )
                  : null,
            ),
          ),
          
          ListTile(
            leading: const Icon(Icons.task_alt, color: Color(0xFF6C5CE7)),
            title: Text(isArabic ? 'المهام' : 'Tasks'),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          
          ListTile(
            leading: const Icon(Icons.settings, color: Color(0xFF6C5CE7)),
            title: Text(isArabic ? 'الإعدادات' : 'Settings'),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/account-settings');
            },
          ),
          
          const Divider(),
          
          ListTile(
            leading: const Icon(Icons.language, color: Color(0xFF6C5CE7)),
            title: Text(isArabic ? 'اللغة' : 'Language'),
            trailing: Text(
              isArabic ? 'العربية' : 'English',
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onLanguageToggle();
            },
          ),
          
          ListTile(
            leading: Icon(
              widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: const Color(0xFF6C5CE7),
            ),
            title: Text(isArabic ? 'المظهر' : 'Theme'),
            trailing: Text(
              widget.isDarkMode 
                  ? (isArabic ? 'داكن' : 'Dark')
                  : (isArabic ? 'فاتح' : 'Light'),
              style: TextStyle(color: Colors.grey[600]),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onThemeToggle();
            },
          ),
          
          const Spacer(),
          
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: Text(
              isArabic ? 'تسجيل الخروج' : 'Logout',
              style: const TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              _showLogoutDialog(context, isArabic);
            },
          ),
          
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, bool isArabic) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
        content: Text(
          isArabic 
              ? 'هل تريد تسجيل الخروج من التطبيق؟'
              : 'Are you sure you want to logout?'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(isArabic ? 'إلغاء' : 'Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacementNamed(context, '/');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
          ),
        ],
      ),
    );
  }
}
