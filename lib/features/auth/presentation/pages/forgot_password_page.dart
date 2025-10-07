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

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handlePasswordReset() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
        AuthPasswordResetRequested(
          email: _emailController.text.trim(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('استعادة كلمة المرور'),
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
              if (state is AuthPasswordResetSent) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('تم إرسال رابط استعادة كلمة المرور إلى بريدك الإلكتروني'),
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
                    const SizedBox(height: AppConstants.spacingXXL),
                    
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
                            Icons.lock_reset,
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
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // Title and Description
                    Text(
                      'استعادة كلمة المرور',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.primaryGolden,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingSM),
                    Text(
                      'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لاستعادة كلمة المرور',
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
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // Reset Password Button
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        return GoldenButton(
                          text: 'إرسال رابط الاستعادة',
                          onPressed: state is AuthLoading ? null : _handlePasswordReset,
                          isLoading: state is AuthLoading,
                          icon: Icons.send,
                        );
                      },
                    ),
                    
                    const SizedBox(height: AppConstants.spacingLG),
                    
                    // Back to Login
                    TextButton(
                      onPressed: () {
                        context.go(AppConstants.routeLogin);
                      },
                      child: Text(
                        'العودة إلى تسجيل الدخول',
                        style: TextStyle(
                          color: AppColors.primaryGolden,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: AppConstants.spacingXXL),
                    
                    // Help Text
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingMD),
                      decoration: BoxDecoration(
                        color: AppColors.lightGray,
                        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        border: Border.all(
                          color: AppColors.primaryGolden.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppColors.primaryGolden,
                            size: AppConstants.iconSizeMD,
                          ),
                          const SizedBox(width: AppConstants.spacingMD),
                          Expanded(
                            child: Text(
                              'إذا لم تجد الرسالة في صندوق الوارد، تحقق من مجلد الرسائل المزعجة',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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