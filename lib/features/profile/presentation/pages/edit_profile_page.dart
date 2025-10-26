import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../auth/presentation/bloc/auth_bloc.dart';
import '../../../auth/presentation/bloc/auth_event.dart';
import '../../../auth/presentation/bloc/auth_state.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  String? _usernameError;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  void _loadCurrentUserData() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      _usernameController.text = authState.user.username ?? '';
    } else if (authState is AuthRegistered) {
      _usernameController.text = authState.user.username ?? '';
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      // Request permission
      if (source == ImageSource.camera) {
        final status = await Permission.camera.request();
        if (!status.isGranted) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفض إذن الكاميرا'),
              ),
            );
          }
          return;
        }
      } else {
        final status = await Permission.photos.request();
        if (!status.isGranted && !status.isLimited) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('تم رفض إذن الصور'),
              ),
            );
          }
          return;
        }
      }

      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 1000,
        maxHeight: 1000,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
          ),
        );
      }
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppConstants.borderRadiusLarge),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('التقاط صورة'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('اختيار من المعرض'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.cancel),
              title: const Text('إلغاء'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });

    try {
      // Convert image to base64 or send file path
      String? profileImagePath = _selectedImage?.path;

      context.read<AuthBloc>().add(
            AuthProfileUpdateRequested(
              username: _usernameController.text,
              profileImage: profileImagePath,
            ),
          );

      // The BlocListener will handle the success state
      // Don't pop immediately, let the listener handle it
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          // Check if it's a username error
          if (state.message.contains('اسم المستخدم مستخدم بالفعل') ||
              state.message.toLowerCase().contains('username')) {
            setState(() {
              _usernameError = state.message;
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        } else if (state is AuthAuthenticated || state is AuthRegistered) {
          // Clear any errors on success
          if (_usernameError != null) {
            setState(() {
              _usernameError = null;
            });
          }
          // Show success message and close page
          if (mounted && _isLoading) {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('تم تحديث الملف الشخصي بنجاح'),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          }
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: const Text('تعديل الملف الشخصي'),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          shape: BoxShape.circle,
                          boxShadow: AppColors.cardShadowMedium,
                          border: Border.all(
                            color: AppColors.primaryGolden,
                            width: 3,
                          ),
                        ),
                        child: _selectedImage != null
                            ? ClipOval(
                                child: Image.file(
                                  _selectedImage!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : const Icon(
                                Icons.person,
                                size: 60,
                                color: AppColors.primaryGolden,
                              ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            gradient: AppColors.goldenGradient,
                            shape: BoxShape.circle,
                            boxShadow: AppColors.cardShadowSmall,
                          ),
                          child: GestureDetector(
                            onTap: _showImageSourceDialog,
                            child: const Icon(
                              Icons.camera_alt,
                              color: AppColors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXXL),

                // Username
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: 'اسم المستخدم',
                    prefixIcon: const Icon(Icons.account_circle),
                    errorText: _usernameError,
                    errorMaxLines: 2,
                    border: _usernameError != null
                        ? OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: const BorderSide(color: Colors.red, width: 2),
                          )
                        : OutlineInputBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: _usernameError != null
                          ? const BorderSide(color: Colors.red, width: 2)
                          : BorderSide(color: Colors.grey.shade300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      borderSide: _usernameError != null
                          ? const BorderSide(color: Colors.red, width: 2)
                          : const BorderSide(color: AppColors.primaryGolden, width: 2),
                    ),
                    filled: true,
                    fillColor: _usernameError != null
                        ? Colors.red.shade50
                        : Theme.of(context).cardColor,
                  ),
                  onChanged: (value) {
                    // Clear error when user starts typing
                    if (_usernameError != null && _formKey.currentState!.validate()) {
                      setState(() {
                        _usernameError = null;
                      });
                    }
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'يرجى إدخال اسم المستخدم';
                    }
                    if (value.length < 3) {
                      return 'اسم المستخدم يجب أن يكون 3 أحرف على الأقل';
                    }
                    return null;
                  },
                ),
                if (_usernameError != null) ...[
                  const SizedBox(height: AppConstants.spacingSM),
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMD),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error_outline, color: Colors.red.shade700, size: 20),
                        const SizedBox(width: AppConstants.spacingSM),
                        Expanded(
                          child: Text(
                            _usernameError!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                const SizedBox(height: AppConstants.spacingXXL),

                // Save Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGolden,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingLG),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    elevation: 4,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.white),
                          ),
                        )
                      : const Text(
                          'حفظ التغييرات',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

