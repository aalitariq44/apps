import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  final VoidCallback onLanguageToggle;
  final VoidCallback onSignUpComplete;

  const SignUpScreen({
    super.key,
    required this.onLanguageToggle,
    required this.onSignUpComplete,
  });

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
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
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  String? _validateName(String? value) {
    final locale = Localizations.localeOf(context);
    if (value == null || value.isEmpty) {
      return locale.languageCode == 'ar' ? 'يرجى إدخال الاسم' : 'Please enter your name';
    }
    if (value.length < 2) {
      return locale.languageCode == 'ar' ? 'الاسم قصير جداً' : 'Name is too short';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final locale = Localizations.localeOf(context);
    if (value == null || value.isEmpty) {
      return locale.languageCode == 'ar' ? 'يرجى إدخال البريد الإلكتروني' : 'Please enter your email';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return locale.languageCode == 'ar' ? 'بريد إلكتروني غير صحيح' : 'Invalid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    final locale = Localizations.localeOf(context);
    if (value == null || value.isEmpty) {
      return locale.languageCode == 'ar' ? 'يرجى إدخال كلمة المرور' : 'Please enter your password';
    }
    if (value.length < 6) {
      return locale.languageCode == 'ar' 
          ? 'كلمة المرور يجب أن تكون 6 أحرف على الأقل' 
          : 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    final locale = Localizations.localeOf(context);
    if (value == null || value.isEmpty) {
      return locale.languageCode == 'ar' ? 'يرجى تأكيد كلمة المرور' : 'Please confirm your password';
    }
    if (value != _passwordController.text) {
      return locale.languageCode == 'ar' ? 'كلمة المرور غير متطابقة' : 'Passwords do not match';
    }
    return null;
  }

  void _handleSignUp() async {
    // تجاوز شاشة التسجيل مباشرة بدون التحقق من الحقول
    widget.onSignUpComplete();
  }

  void _navigateToLogin() {
    // In a real app, this would navigate to login screen
    widget.onSignUpComplete();
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      body: Container(
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
        child: SafeArea(
          child: Column(
            children: [
              // App Bar
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: Icon(
                        isArabic ? Icons.arrow_forward : Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: widget.onLanguageToggle,
                      icon: const Icon(Icons.language, color: Colors.white),
                    ),
                  ],
                ),
              ),
              
              // Content
              Expanded(
                child: Container(
                  margin: const EdgeInsets.only(top: 20),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: FadeTransition(
                    opacity: _fadeAnimation,
                    child: SlideTransition(
                      position: _slideAnimation,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const SizedBox(height: 20),
                            
                            // Title
                            Text(
                              isArabic ? 'إنشاء حساب جديد' : 'Create Account',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3436),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            Text(
                              isArabic 
                                  ? 'أدخل معلوماتك لإنشاء حساب جديد' 
                                  : 'Enter your details to create a new account',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[600],
                              ),
                              textAlign: TextAlign.center,
                            ),
                            
                            const SizedBox(height: 40),
                            
                            // Form
                            Expanded(
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Name Field
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
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Email Field
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
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Password Field
                                    TextFormField(
                                      controller: _passwordController,
                                      validator: _validatePassword,
                                      obscureText: _obscurePassword,
                                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                                      decoration: InputDecoration(
                                        labelText: isArabic ? 'كلمة المرور' : 'Password',
                                        prefixIcon: const Icon(Icons.lock_outline),
                                        suffixIcon: IconButton(
                                          onPressed: () {
                                            setState(() {
                                              _obscurePassword = !_obscurePassword;
                                            });
                                          },
                                          icon: Icon(
                                            _obscurePassword ? Icons.visibility : Icons.visibility_off,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Confirm Password Field
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
                                        enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.grey[300]!),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: const BorderSide(color: Color(0xFF6C5CE7)),
                                        ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 30),
                                    
                                    // Sign Up Button
                                    SizedBox(
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: _isLoading ? null : _handleSignUp,
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: const Color(0xFF6C5CE7),
                                          foregroundColor: Colors.white,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          elevation: 2,
                                        ),
                                        child: _isLoading
                                            ? const CircularProgressIndicator(color: Colors.white)
                                            : Text(
                                                isArabic ? 'إنشاء حساب' : 'Sign Up',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                    
                                    const SizedBox(height: 20),
                                    
                                    // Login Link
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          isArabic ? 'لديك حساب بالفعل؟ ' : 'Already have an account? ',
                                          style: TextStyle(color: Colors.grey[600]),
                                        ),
                                        GestureDetector(
                                          onTap: _navigateToLogin,
                                          child: Text(
                                            isArabic ? 'تسجيل الدخول' : 'Login',
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
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
