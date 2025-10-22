import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../widgets/auth_text_field.dart';
import '../widgets/golden_button.dart';
import '../../../../shared/widgets/themed_dropdown.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerFormKey = GlobalKey<FormState>();
  final _regUsername = TextEditingController();
  final _regEmail = TextEditingController();
  final _regPassword = TextEditingController();
  final _regConfirm = TextEditingController();
  final _regFirstName = TextEditingController();
  final _regLastName = TextEditingController();
  final _regPhone = TextEditingController();
  bool _regObscure = true;
  bool _regConfirmObscure = true;
  String? _selectedGender;
  String? _selectedRole;

  @override
  void dispose() {
    _regUsername.dispose();
    _regEmail.dispose();
    _regPassword.dispose();
    _regConfirm.dispose();
    _regFirstName.dispose();
    _regLastName.dispose();
    _regPhone.dispose();
    super.dispose();
  }

  void _submitRegister() {
    if (_registerFormKey.currentState?.validate() ?? false) {
        // Check if gender and role are selected
        if (_selectedGender == null || _selectedRole == null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('يرجى اختيار الجنس ونوع الحساب'),
              backgroundColor: Colors.red,
            ),
          );
          return;
        }

        context.read<AuthBloc>().add(AuthRegisterRequested(
          email: _regEmail.text.trim(),
          password: _regPassword.text,
          confirmPassword: _regConfirm.text,
          username: _regUsername.text.trim(),
          firstName: _regFirstName.text.trim(),
          lastName: _regLastName.text.trim(),
          phone: _regPhone.text.trim(),
          gender: _selectedGender!,
          role: _selectedRole!,
        ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.surface,
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: BlocListener<AuthBloc, AuthState>(
            listener: (context, state) {
              if (state is AuthAuthenticated || state is AuthRegistered) {
                context.go(AppConstants.routeHome);
              } else if (state is AuthError) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(state.message),
                  backgroundColor: AppColors.errorRed,
                ));
              }
            },
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    left: AppConstants.spacingLG,
                    right: AppConstants.spacingLG,
                    top: AppConstants.spacingXL,
                    bottom: MediaQuery.of(context).viewInsets.bottom + AppConstants.spacingXL,
                  ),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight - AppConstants.spacingXL * 2,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildHeader(),
                          const SizedBox(height: AppConstants.spacingXL),
                          Expanded(
                            child: _buildRegisterCard(context),
                          ),
                          const SizedBox(height: AppConstants.spacingLG),
                          _buildBackToLogin(),
                          SizedBox(height: MediaQuery.of(context).viewInsets.bottom > 0 ? AppConstants.spacingLG : 0),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  /// 🔶 Golden Header
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: AppConstants.spacingXL,
        horizontal: AppConstants.spacingLG,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                   'WEDLY',
                   style: TextStyle(
                     color: Theme.of(context).brightness == Brightness.dark 
                         ? Colors.white 
                         : Colors.black,
                     fontSize: 22,
                     fontWeight: FontWeight.bold,
                     letterSpacing: 1.2,
                   ),
                 ),
                 const SizedBox(height: 6),
                 Text(
                   'إنشاء حساب جديد',
                   style: TextStyle(
                     color: Theme.of(context).brightness == Brightness.dark 
                         ? Colors.white70 
                         : Colors.black87,
                     fontSize: 14,
                   ),
                 ),
              ],
            ),
          ),
            Icon(
              Icons.person_add_rounded,
              color: Theme.of(context).brightness == Brightness.dark 
                  ? Colors.white 
                  : Colors.black,
              size: 32,
            ),
        ],
      ),
    );
  }

  /// 🧩 Register Card
  Widget _buildRegisterCard(BuildContext context) {
    return Container(
      key: const ValueKey('registerCard'),
      padding: const EdgeInsets.all(AppConstants.spacingLG),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Form(
        key: _registerFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'إنشاء حساب جديد',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            // Username Field
            AuthTextField(
              controller: _regUsername,
              label: 'اسم المستخدم',
              hint: 'أدخل اسم المستخدم',
              prefixIcon: Icons.account_circle_outlined,
              textCapitalization: TextCapitalization.none,
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال اسم المستخدم';
                if (v.length < 3) return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
                if (!RegExp(r'^[a-zA-Z0-9_]+$').hasMatch(v)) return 'اسم المستخدم يمكن أن يحتوي على أحرف وأرقام و_ فقط';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            // Email Field
            AuthTextField(
              controller: _regEmail,
              label: 'البريد الإلكتروني',
              hint: 'example@mail.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'بريد غير صالح';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            // First Name Field
            AuthTextField(
              controller: _regFirstName,
              label: 'الاسم الأول',
              hint: 'أدخل اسمك الأول',
              prefixIcon: Icons.person_outline,
              textCapitalization: TextCapitalization.words,
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال الاسم الأول';
                if (v.length < 2) return 'الاسم الأول يجب أن يكون حرفين على الأقل';
                if (!RegExp(r'^[a-zA-Z\u0600-\u06FF\s]+$').hasMatch(v)) return 'الاسم يمكن أن يحتوي على أحرف فقط';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            
            // Phone Field
            AuthTextField(
              controller: _regPhone,
              label: 'رقم الهاتف',
              hint: '01xxxxxxxx',
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
              textCapitalization: TextCapitalization.none,
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال رقم الهاتف';
                if (v.length != 11) return 'رقم الهاتف يجب أن يكون 11 رقم';
                if (!v.startsWith('01')) return 'رقم الهاتف يجب أن يبدأ بـ 01';
                if (!RegExp(r'^01[0-9]{9}$').hasMatch(v)) return 'رقم هاتف غير صالح';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            // Gender Selection
            GenderDropdown(
              value: _selectedGender,
              onChanged: (value) => setState(() => _selectedGender = value!),
              validator: (v) => v == null ? 'يرجى اختيار الجنس' : null,
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            // Role Selection
            RoleDropdown(
              value: _selectedRole,
              onChanged: (value) => setState(() => _selectedRole = value!),
              validator: (v) => v == null ? 'يرجى اختيار نوع الحساب' : null,
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            // Password Field
            AuthTextField(
              controller: _regPassword,
              label: 'كلمة المرور',
              hint: '********',
              prefixIcon: Icons.lock_outline,
              obscureText: _regObscure,
              textCapitalization: TextCapitalization.none,
              suffixIcon: IconButton(
                icon: Icon(_regObscure ? Icons.visibility : Icons.visibility_off, color: AppColors.textSecondary),
                onPressed: () => setState(() => _regObscure = !_regObscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال كلمة المرور';
                if (v.length < AppConstants.minPasswordLength) return 'كلمة المرور يجب أن تكون ${AppConstants.minPasswordLength} أحرف على الأقل';
                if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*\d)').hasMatch(v)) return 'كلمة المرور يجب أن تحتوي على أحرف وأرقام';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMD),
            
            // Confirm Password Field
            AuthTextField(
              controller: _regConfirm,
              label: 'تأكيد كلمة المرور',
              hint: 'أعد إدخال كلمة المرور',
              prefixIcon: Icons.lock_reset_outlined,
              obscureText: _regConfirmObscure,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                icon: Icon(_regConfirmObscure ? Icons.visibility : Icons.visibility_off, color: AppColors.textSecondary),
                onPressed: () => setState(() => _regConfirmObscure = !_regConfirmObscure),
              ),
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى تأكيد كلمة المرور';
                if (v != _regPassword.text) return 'كلمة المرور غير متطابقة';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingLG),
            
            // Submit Button
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) => GoldenButton(
                text: 'إنشاء الحساب',
                onPressed: state is AuthLoading ? null : _submitRegister,
                isLoading: state is AuthLoading,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            _socialRow(),
          ],
        ),
      ),
    );
  }

  /// 🔗 Back to Login
  Widget _buildBackToLogin() {
    return Center(
      child: TextButton(
        onPressed: () => context.pop(),
         child: Text(
           'هل لديك حساب بالفعل؟ تسجيل الدخول',
           style: Theme.of(context).textTheme.bodyMedium?.copyWith(
             color: Theme.of(context).brightness == Brightness.dark 
                 ? Colors.white 
                 : Colors.black,
             fontWeight: FontWeight.w600,
           ),
         ),
      ),
    );
  }

  /// 🌐 Social Login Row
  Widget _socialRow() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'أو',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            Expanded(child: Divider(color: Theme.of(context).colorScheme.outline)),
          ],
        ),
        const SizedBox(height: AppConstants.spacingMD),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Flexible(child: _buildSocialButton(Icons.g_mobiledata, 'Google')),
            Flexible(child: _buildSocialButton(Icons.facebook, 'Facebook')),
            
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, String label) {
    return InkWell(
      onTap: () {
        // TODO: Implement social login
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Theme.of(context).colorScheme.onSurface),
            const SizedBox(width: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }
}