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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthLoginRequested(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              if (state is AuthAuthenticated) {
                context.go(AppConstants.routeHome);
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
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // WEDLY Logo and Title
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
                            size: 64,
                            color: AppColors.white,
                          ),
                          const SizedBox(height: AppConstants.spacingMD),
                          Text(
                            AppConstants.appName,
                            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingSM),
                          Text(
                            AppConstants.appTagline,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppColors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // Welcome Text
                    Text(
                      'مرحباً بك في WEDLY',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryGolden,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    Text(
                      'سجل دخولك للوصول إلى خدمات الزفاف الفاخرة',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
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
                    
                    const SizedBox(height: AppConstants.spacingSM),
                    
                    // Forgot Password
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton(
                        onPressed: () {
                          context.go(AppConstants.routeForgotPassword);
                        },
                        child: Text(
                          'نسيت كلمة المرور؟',
                          style: TextStyle(
                            color: AppColors.primaryGolden,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingLG),
                    
                    // Login Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return GoldenButton(
                          text: 'تسجيل الدخول',
                          onPressed: state is AuthLoading ? null : _handleLogin,
                          isLoading: state is AuthLoading,
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingLG),
                    
                    // Divider
                    Row(
                      children: [
                        const Expanded(child: Divider()),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingMD),
                          child: Text(
                            'أو',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const Expanded(child: Divider()),
                      ],
                    ),
                    
                    const SizedBox(height: AppConstants.spacingLG),
                    
                    // Register Button
                    OutlinedButton(
                      onPressed: () {
                        context.go(AppConstants.routeRegister);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: AppColors.primaryGolden),
                        minimumSize: const Size(double.infinity, AppConstants.buttonHeight),
                      ),
                      child: Text(
                        'إنشاء حساب جديد',
                        style: TextStyle(
                          color: AppColors.primaryGolden,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
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