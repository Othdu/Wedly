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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginFormKey = GlobalKey<FormState>();
  final _loginEmail = TextEditingController();
  final _loginPassword = TextEditingController();
  bool _loginObscure = true;

  @override
  void dispose() {
    _loginEmail.dispose();
    _loginPassword.dispose();
    super.dispose();
  }

  void _submitLogin() {
    if (_loginFormKey.currentState?.validate() ?? false) {
      context.read<AuthBloc>().add(AuthLoginRequested(
            email: _loginEmail.text.trim(),
            password: _loginPassword.text,
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
                            child: _buildLoginCard(context),
                          ),
                          const SizedBox(height: AppConstants.spacingLG),
                          _buildRegisterLink(),
                          const SizedBox(height: AppConstants.spacingMD),
                          Center(
                            child: TextButton(
                              onPressed: () => context.go(AppConstants.routeForgotPassword),
                              child: Text(
                                'نسيت كلمة المرور؟',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
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
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Icon(
            Icons.login_rounded,
            color: Theme.of(context).colorScheme.onPrimary,
            size: 32,
          ),
        ],
      ),
    );
  }

  /// 🧩 Login Card
  Widget _buildLoginCard(BuildContext context) {
    return Container(
      key: const ValueKey('loginCard'),
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
        key: _loginFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                'تسجيل الدخول',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            AuthTextField(
              controller: _loginEmail,
              label: 'البريد الإلكتروني',
              hint: 'example@mail.com',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.next,
              validator: (v) {
                if (v == null || v.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(v)) return 'بريد غير صالح';
                return null;
              },
            ),
            const SizedBox(height: AppConstants.spacingMD),
            AuthTextField(
              controller: _loginPassword,
              label: 'كلمة المرور',
              hint: '********',
              prefixIcon: Icons.lock_outline,
              obscureText: _loginObscure,
              textCapitalization: TextCapitalization.none,
              textInputAction: TextInputAction.done,
              suffixIcon: IconButton(
                icon: Icon(_loginObscure ? Icons.visibility : Icons.visibility_off, color: AppColors.textSecondary),
                onPressed: () => setState(() => _loginObscure = !_loginObscure),
              ),
              validator: (v) => v == null || v.isEmpty ? 'يرجى إدخال كلمة المرور' : null,
            ),
            const SizedBox(height: AppConstants.spacingLG),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) => GoldenButton(
                text: 'تسجيل الدخول',
                onPressed: state is AuthLoading ? null : _submitLogin,
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

  /// 🔗 Register Link
  Widget _buildRegisterLink() {
    return Center(
      child: TextButton(
        onPressed: () => context.go(AppConstants.routeRegister),
        child: Text(
          'ليس لديك حساب؟ إنشاء حساب جديد',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.primary,
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