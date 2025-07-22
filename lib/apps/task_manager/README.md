# Task Manager Application

A comprehensive Flutter task management application designed for professional portfolio showcasing.

## Features

### Core Features
- **Task Management**: Create, edit, delete, and view tasks
- **Priority System**: Four levels - Low, Medium, High, Urgent
- **Status Tracking**: Pending, In Progress, Completed, Cancelled
- **Due Date Management**: Full date and time selection
- **Search & Filter**: Search tasks and filter by status
- **Multi-language Support**: English and Arabic localization

### Screens Included

#### 1. Sign Up Screen (تسجيل مستخدم)
- User registration form with validation
- Name, email, password, and confirm password fields
- Smooth animations and modern UI design
- Language toggle functionality

#### 2. Tasks List Screen (قائمة المهام)
- Displays all tasks in an organized list
- Priority and status indicators
- Search functionality
- Filter by task status
- Overdue task warnings
- Floating action button for new task creation
- Navigation drawer with user profile

#### 3. Task Details Screen (تفاصيل المهمة)
- Complete task information display
- Priority and status badges
- Creation and update timestamps
- Quick action buttons (Edit, Delete, Status Toggle)
- Responsive design for different screen sizes

#### 4. Create Task Screen (إنشاء مهمة جديدة)
- Comprehensive form for task creation
- Title and description validation
- Date and time picker integration
- Priority selection with visual indicators
- Real-time form validation

#### 5. Edit Task Screen (تعديل المهمة)
- Pre-populated form with existing task data
- All fields editable including status
- Maintains task history with update timestamps
- Save changes functionality

#### 6. Account Settings Screen (إعدادات الحساب)
- User profile management
- Password change functionality
- Language and theme preferences
- Logout functionality

### Technical Features

#### Design & UI/UX
- **Material Design 3**: Modern Flutter design system
- **Gradient Backgrounds**: Beautiful color gradients
- **Card-based Layout**: Clean and organized information display
- **Smooth Animations**: Fade and slide transitions
- **Responsive Design**: Works on various screen sizes
- **RTL Support**: Full right-to-left support for Arabic

#### User Experience
- **Form Validation**: Real-time input validation
- **Loading Indicators**: Visual feedback during operations
- **Error Handling**: User-friendly error messages
- **Confirmation Dialogs**: Prevent accidental actions
- **Snackbar Notifications**: Success and error notifications

#### Data Management
- **Dummy Data**: Pre-populated with sample tasks
- **State Management**: Efficient state handling
- **Data Models**: Well-structured task and user models
- **CRUD Operations**: Complete Create, Read, Update, Delete functionality

### Localization Support

#### English Features
- Professional terminology
- Clear and concise messaging
- Standard date and time formats

#### Arabic Features (العربية)
- Complete translation of all UI elements
- RTL text alignment
- Arabic date formatting
- Cultural considerations in UX

### Color Scheme
- **Primary**: Purple gradient (#6C5CE7 to #74B9FF)
- **Priority Colors**: 
  - Low: Green
  - Medium: Orange  
  - High: Red
  - Urgent: Purple
- **Status Colors**:
  - Pending: Grey
  - In Progress: Blue
  - Completed: Green
  - Cancelled: Red

### Architecture

```
lib/apps/task_manager/
├── models/
│   ├── task.dart          # Task data model with enums
│   └── user.dart          # User data model
├── screens/
│   ├── signup_screen.dart
│   ├── tasks_list_screen.dart
│   ├── task_details_screen.dart
│   ├── create_task_screen.dart
│   ├── edit_task_screen.dart
│   └── account_settings_screen.dart
├── widgets/
│   └── task_card.dart     # Reusable task display widget
└── task_manager_app.dart  # Main app entry point
```

### Key Highlights for Portfolio

1. **Professional Quality**: Enterprise-level UI/UX design
2. **Comprehensive Features**: Complete task management workflow
3. **Best Practices**: Clean code structure and organization
4. **Accessibility**: Multi-language and RTL support
5. **Modern Flutter**: Latest Flutter features and patterns
6. **Attention to Detail**: Polished animations and interactions

This task manager application demonstrates proficiency in:
- Flutter framework and Dart programming
- Material Design implementation
- State management
- Form handling and validation
- Internationalization (i18n)
- Responsive design
- Animation and transitions
- Clean architecture principles

Perfect for showcasing mobile development skills in professional portfolios and client presentations.
