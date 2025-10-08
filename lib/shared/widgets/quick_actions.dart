import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';

class QuickAction {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const QuickAction({
    required this.title,
    required this.icon,
    required this.onTap,
  });
}

class QuickActions extends StatelessWidget {
  final List<QuickAction> actions;
  final String title;

  const QuickActions({
    super.key,
    required this.actions,
    this.title = 'الإجراءات السريعة',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingLG,
            vertical: AppConstants.spacingMD,
          ),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.primaryGolden,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
        SizedBox(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingLG),
            itemCount: actions.length,
            itemBuilder: (context, index) {
              final action = actions[index];
              return Container(
                width: 100,
                margin: const EdgeInsets.only(right: AppConstants.spacingMD),
                child: GestureDetector(
                  onTap: action.onTap,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingMD),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGolden.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          ),
                          child: Icon(
                            action.icon,
                            color: AppColors.primaryGolden,
                            size: AppConstants.iconSizeLG,
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingSM),
                        Text(
                          action.title,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
