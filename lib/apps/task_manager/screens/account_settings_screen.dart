import 'package:flutter/material.dart';
import '../models/user.dart';

class AccountSettingsScreen extends StatefulWidget {
  final User currentUser;
  final Function(User) onUserUpdated;
  final VoidCallback onLanguageToggle;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;

  const AccountSettingsScreen({
    super.key,
    required this.currentUser,
    required this.onUserUpdated,
    required this.onLanguageToggle,
    required this.onThemeToggle,
    required this.isDarkMode,
  });

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _currentPasswordController;
  late TextEditingController _newPasswordController;
  late TextEditingController _confirmPasswordController;
  
  bool _isEditingProfile = false;
  bool _isChangingPassword = false;
  bool _obscureCurrentPassword = true;
  bool _obscureNewPassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _nameController = TextEditingController(text: widget.currentUser.name);
    _emailController = TextEditingController(text: widget.currentUser.email);
    _currentPasswordController = TextEditingController();
    _newPasswordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    
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
    _nameController.dispose();
    _emailController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال الاسم' : 'Please enter your name';
    }
    if (value.length < 2) {
      return isArabic ? 'الاسم قصير جداً' : 'Name is too short';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال البريد الإلكتروني' : 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return isArabic ? 'بريد إلكتروني غير صحيح' : 'Invalid email address';
    }
    return null;
  }

  String? _validateCurrentPassword(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال كلمة المرور الحالية' : 'Please enter current password';
    }
    return null;
  }

  String? _validateNewPassword(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال كلمة المرور الجديدة' : 'Please enter new password';
    }
    if (value.length < 6) {
      return isArabic 
          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' 
          : 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى تأكيد كلمة المرور' : 'Please confirm password';
    }
    if (value != _newPasswordController.text) {
      return isArabic ? 'كلمة المرور غير متطابقة' : 'Passwords do not match';
    }
    return null;
  }

  void _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      final updatedUser = widget.currentUser.copyWith(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
      );

      widget.onUserUpdated(updatedUser);

      setState(() {
        _isLoading = false;
        _isEditingProfile = false;
      });

      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'تم تحديث الملف الشخصي بنجاح' : 'Profile updated successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _changePassword() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
        _isChangingPassword = false;
      });

      // Clear password fields
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();

      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'تم تغيير كلمة المرور بنجاح' : 'Password changed successfully',
          ),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _showLogoutDialog(bool isArabic) {
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
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
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
                isArabic ? 'إعدادات الحساب' : 'Account Settings',
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
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.currentUser.avatar != null
                            ? NetworkImage(widget.currentUser.avatar!)
                            : null,
                        child: widget.currentUser.avatar == null
                            ? Text(
                                widget.currentUser.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF6C5CE7),
                                ),
                              )
                            : null,
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
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      
                      // Profile Information Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.person, color: Color(0xFF6C5CE7)),
                                  const SizedBox(width: 12),
                                  Text(
                                    isArabic ? 'معلومات الملف الشخصي' : 'Profile Information',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const Spacer(),
                                  if (!_isEditingProfile)
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _isEditingProfile = true;
                                        });
                                      },
                                      icon: const Icon(Icons.edit, color: Color(0xFF6C5CE7)),
                                    ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              if (_isEditingProfile) ...[
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _nameController,
                                        validator: _validateName,
                                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                        decoration: InputDecoration(
                                          labelText: isArabic ? 'الاسم الكامل' : 'Full Name',
                                          prefixIcon: const Icon(Icons.person_outline),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _emailController,
                                        validator: _validateEmail,
                                        keyboardType: TextInputType.emailAddress,
                                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                        decoration: InputDecoration(
                                          labelText: isArabic ? 'البريد الإلكتروني' : 'Email Address',
                                          prefixIcon: const Icon(Icons.email_outlined),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isEditingProfile = false;
                                                  _nameController.text = widget.currentUser.name;
                                                  _emailController.text = widget.currentUser.email;
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey[300],
                                                foregroundColor: Colors.grey[700],
                                              ),
                                              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _isLoading ? null : _updateProfile,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF6C5CE7),
                                                foregroundColor: Colors.white,
                                              ),
                                              child: _isLoading
                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                  : Text(isArabic ? 'حفظ' : 'Save'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                _buildInfoRow(
                                  icon: Icons.person_outline,
                                  label: isArabic ? 'الاسم' : 'Name',
                                  value: widget.currentUser.name,
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  icon: Icons.email_outlined,
                                  label: isArabic ? 'البريد الإلكتروني' : 'Email',
                                  value: widget.currentUser.email,
                                ),
                                const SizedBox(height: 16),
                                _buildInfoRow(
                                  icon: Icons.calendar_today,
                                  label: isArabic ? 'تاريخ الانضمام' : 'Join Date',
                                  value: _formatJoinDate(widget.currentUser.joinDate, isArabic),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Password Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.lock, color: Color(0xFF6C5CE7)),
                                  const SizedBox(width: 12),
                                  Text(
                                    isArabic ? 'تغيير كلمة المرور' : 'Change Password',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              if (_isChangingPassword) ...[
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _currentPasswordController,
                                        validator: _validateCurrentPassword,
                                        obscureText: _obscureCurrentPassword,
                                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                        decoration: InputDecoration(
                                          labelText: isArabic ? 'كلمة المرور الحالية' : 'Current Password',
                                          prefixIcon: const Icon(Icons.lock_outline),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscureCurrentPassword = !_obscureCurrentPassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscureCurrentPassword ? Icons.visibility : Icons.visibility_off,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _newPasswordController,
                                        validator: _validateNewPassword,
                                        obscureText: _obscureNewPassword,
                                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                        decoration: InputDecoration(
                                          labelText: isArabic ? 'كلمة المرور الجديدة' : 'New Password',
                                          prefixIcon: const Icon(Icons.lock_outline),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscureNewPassword = !_obscureNewPassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscureNewPassword ? Icons.visibility : Icons.visibility_off,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      TextFormField(
                                        controller: _confirmPasswordController,
                                        validator: _validateConfirmPassword,
                                        obscureText: _obscureConfirmPassword,
                                        textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                        decoration: InputDecoration(
                                          labelText: isArabic ? 'تأكيد كلمة المرور' : 'Confirm Password',
                                          prefixIcon: const Icon(Icons.lock_outline),
                                          suffixIcon: IconButton(
                                            onPressed: () {
                                              setState(() {
                                                _obscureConfirmPassword = !_obscureConfirmPassword;
                                              });
                                            },
                                            icon: Icon(
                                              _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                                            ),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: () {
                                                setState(() {
                                                  _isChangingPassword = false;
                                                  _currentPasswordController.clear();
                                                  _newPasswordController.clear();
                                                  _confirmPasswordController.clear();
                                                });
                                              },
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.grey[300],
                                                foregroundColor: Colors.grey[700],
                                              ),
                                              child: Text(isArabic ? 'إلغاء' : 'Cancel'),
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: ElevatedButton(
                                              onPressed: _isLoading ? null : _changePassword,
                                              style: ElevatedButton.styleFrom(
                                                backgroundColor: const Color(0xFF6C5CE7),
                                                foregroundColor: Colors.white,
                                              ),
                                              child: _isLoading
                                                  ? const CircularProgressIndicator(color: Colors.white)
                                                  : Text(isArabic ? 'تغيير' : 'Change'),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ] else ...[
                                ElevatedButton.icon(
                                  onPressed: () {
                                    setState(() {
                                      _isChangingPassword = true;
                                    });
                                  },
                                  icon: const Icon(Icons.lock_reset),
                                  label: Text(isArabic ? 'تغيير كلمة المرور' : 'Change Password'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF6C5CE7),
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // App Settings Section
                      Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.settings, color: Color(0xFF6C5CE7)),
                                  const SizedBox(width: 12),
                                  Text(
                                    isArabic ? 'إعدادات التطبيق' : 'App Settings',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              ListTile(
                                leading: const Icon(Icons.language, color: Color(0xFF6C5CE7)),
                                title: Text(isArabic ? 'اللغة' : 'Language'),
                                subtitle: Text(isArabic ? 'العربية' : 'English'),
                                trailing: const Icon(Icons.arrow_forward_ios),
                                onTap: widget.onLanguageToggle,
                              ),
                              
                              ListTile(
                                leading: Icon(
                                  widget.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                                  color: const Color(0xFF6C5CE7),
                                ),
                                title: Text(isArabic ? 'المظهر' : 'Theme'),
                                subtitle: Text(
                                  widget.isDarkMode 
                                      ? (isArabic ? 'الوضع الداكن' : 'Dark Mode')
                                      : (isArabic ? 'الوضع الفاتح' : 'Light Mode'),
                                ),
                                trailing: Switch(
                                  value: widget.isDarkMode,
                                  onChanged: (value) => widget.onThemeToggle(),
                                  activeColor: const Color(0xFF6C5CE7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Logout Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _showLogoutDialog(isArabic),
                          icon: const Icon(Icons.logout),
                          label: Text(isArabic ? 'تسجيل الخروج' : 'Logout'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
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

  Widget _buildInfoRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[600], size: 20),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: Text(
            label,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _formatJoinDate(DateTime date, bool isArabic) {
    final months = isArabic 
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
           'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    
    if (isArabic) {
      return '$day $month $year';
    } else {
      return '$month $day, $year';
    }
  }
}
