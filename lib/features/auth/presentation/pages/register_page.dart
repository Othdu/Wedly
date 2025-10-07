import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:wedly/features/auth/presentation/bloc/auth_event.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/golden_button.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthRegisterRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
          fullName: _fullNameController.text.trim(),
          phone: _phoneController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('إنشاء حساب جديد'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.white,
              AppColors.lightGray,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthRegistered) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إنشاء الحساب بنجاح! يرجى التحقق من بريدك الإلكتروني'),
                    backgroundColor: AppColors.success,
                  ),
                );
                context.go(AppConstants.routeLogin);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            },
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppConstants.spacingLG),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // WEDLY Logo
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingLG),
                      decoration: BoxDecoration(
                        gradient: AppColors.goldenGradient,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
                        boxShadow: AppColors.goldenShadowMedium,
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.favorite,
                            size: 48,
                            color: AppColors.white,
                          ),
                          const SizedBox(height: AppConstants.spacingSM),
                          Text(
                            AppConstants.appName,
                            style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // Welcome Text
                    Text(
                      'انضم إلى WEDLY',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryGolden,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    Text(
                      'أنشئ حسابك للوصول إلى أفضل خدمات الزفاف',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // Full Name Field
                    AuthTextField(
                      controller: _fullNameController,
                      label: 'الاسم الكامل',
                      hint: 'أدخل اسمك الكامل',
                      prefixIcon: Icons.person_outline,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال الاسم الكامل';
                        }
                        if (value.length < 2) {
                          return 'الاسم يجب أن يكون حرفين على الأقل';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingMD),
                    
                    // Email Field
                    AuthTextField(
                      controller: _emailController,
                      label: 'البريد الإلكتروني',
                      hint: 'أدخل بريدك الإلكتروني',
                      prefixIcon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال البريد الإلكتروني';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'يرجى إدخال بريد إلكتروني صحيح';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingMD),
                    
                    // Phone Field
                    AuthTextField(
                      controller: _phoneController,
                      label: 'رقم الهاتف',
                      hint: 'أدخل رقم هاتفك',
                      prefixIcon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال رقم الهاتف';
                        }
                        if (value.length < 10) {
                          return 'رقم الهاتف يجب أن يكون 10 أرقام على الأقل';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingMD),
                    
                    // Password Field
                    AuthTextField(
                      controller: _passwordController,
                      label: 'كلمة المرور',
                      hint: 'أدخل كلمة المرور',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscurePassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscurePassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى إدخال كلمة المرور';
                        }
                        if (value.length < AppConstants.minPasswordLength) {
                          return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingMD),
                    
                    // Confirm Password Field
                    AuthTextField(
                      controller: _confirmPasswordController,
                      label: 'تأكيد كلمة المرور',
                      hint: 'أعد إدخال كلمة المرور',
                      prefixIcon: Icons.lock_outline,
                      obscureText: _obscureConfirmPassword,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureConfirmPassword ? Icons.visibility : Icons.visibility_off,
                          color: AppColors.textSecondary,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'يرجى تأكيد كلمة المرور';
                        }
                        if (value != _passwordController.text) {
                          return 'كلمة المرور غير متطابقة';
                        }
                        return null;
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingLG),
                    
                    // Register Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return GoldenButton(
                          text: 'إنشاء الحساب',
                          onPressed: state is AuthLoading ? null : _handleRegister,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingLG),
                    
                    // Login Link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'لديك حساب بالفعل؟ ',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            context.go(AppConstants.routeLogin);
                          },
                          child: Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              color: AppColors.primaryGolden,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}