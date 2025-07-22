import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:interfaces/l10n/app_localizations.dart';
import '../../core/theme.dart';
import 'models/task.dart';
import 'models/user.dart';
import 'screens/signup_screen.dart';
import 'screens/tasks_list_screen.dart';
import 'screens/task_details_screen.dart';
import 'screens/create_task_screen.dart';
import 'screens/edit_task_screen.dart';
import 'screens/account_settings_screen.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  Locale _currentLocale = const Locale('en', '');
  List<Task> _tasks = Task.getDummyTasks();
  User _currentUser = User.getDummyUser();
  bool _isDarkMode = false;

  void _toggleLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en'
          ? const Locale('ar', '')
          : const Locale('en', '');
    });
  }

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  void _addTask(Task task) {
    setState(() {
      _tasks.add(task);
    });
  }

  void _updateTask(Task updatedTask) {
    setState(() {
      final index = _tasks.indexWhere((task) => task.id == updatedTask.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
      }
    });
  }

  void _deleteTask(String taskId) {
    setState(() {
      _tasks.removeWhere((task) => task.id == taskId);
    });
  }

  void _updateUser(User updatedUser) {
    setState(() {
      _currentUser = updatedUser;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Task Manager',
      theme: AppTheme.lightTheme,
      locale: _currentLocale,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('ar', ''),
      ],
      home: SignUpScreen(
        onLanguageToggle: _toggleLanguage,
        onSignUpComplete: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => TasksListScreen(
                tasks: _tasks,
                currentUser: _currentUser,
                onLanguageToggle: _toggleLanguage,
                onThemeToggle: _toggleTheme,
                isDarkMode: _isDarkMode,
              ),
            ),
          );
        },
      ),
      routes: {
        '/tasks': (context) => TasksListScreen(
              tasks: _tasks,
              currentUser: _currentUser,
              onLanguageToggle: _toggleLanguage,
              onThemeToggle: _toggleTheme,
              isDarkMode: _isDarkMode,
            ),
        '/create-task': (context) => CreateTaskScreen(
              onTaskCreated: _addTask,
              onLanguageToggle: _toggleLanguage,
            ),
        '/account-settings': (context) => AccountSettingsScreen(
              currentUser: _currentUser,
              onUserUpdated: _updateUser,
              onLanguageToggle: _toggleLanguage,
              onThemeToggle: _toggleTheme,
              isDarkMode: _isDarkMode,
            ),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/task-details') {
          final args = settings.arguments as Map<String, dynamic>?;
          final task = args?['task'] as Task?;
          if (task == null) {
            return MaterialPageRoute(
              builder: (context) => TasksListScreen(
                tasks: _tasks,
                currentUser: _currentUser,
                onLanguageToggle: _toggleLanguage,
                onThemeToggle: _toggleTheme,
                isDarkMode: _isDarkMode,
              ),
            );
          }
          return MaterialPageRoute(
            builder: (context) => TaskDetailsScreen(
              task: task,
              onTaskUpdated: _updateTask,
              onTaskDeleted: _deleteTask,
              onLanguageToggle: _toggleLanguage,
            ),
          );
        }

        if (settings.name == '/edit-task') {
          final args = settings.arguments as Map<String, dynamic>?;
          final task = args?['task'] as Task?;
          if (task == null) {
            return MaterialPageRoute(
              builder: (context) => TasksListScreen(
                tasks: _tasks,
                currentUser: _currentUser,
                onLanguageToggle: _toggleLanguage,
                onThemeToggle: _toggleTheme,
                isDarkMode: _isDarkMode,
              ),
            );
          }
          return MaterialPageRoute(
            builder: (context) => EditTaskScreen(
              task: task,
              onTaskUpdated: _updateTask,
              onLanguageToggle: _toggleLanguage,
            ),
          );
        }

        return null;
      },
    );
  }
}
