import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/home_bloc.dart';
import '../bloc/home_state.dart';
import '../bloc/home_event.dart';
import '../widgets/featured_service_card.dart';

class FeaturedServicesPage extends StatelessWidget {
  const FeaturedServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryGolden),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'الخدمات المميزة',
          style: TextStyle(
            color: AppColors.primaryGolden,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<HomeBloc, HomeState>(
        builder: (context, state) {
          if (state is! HomeLoaded) {
            return const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGolden),
              ),
            );
          }

          final featured = state.featuredServices;
          if (featured.isEmpty) {
            return Center(
              child: Text(
                'لا توجد خدمات مميزة حالياً',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: featured.length,
              itemBuilder: (context, index) {
                final service = featured[index];
                return FeaturedServiceCard(
                  service: service,
                  onTap: () {
                    context.read<HomeBloc>().add(
                          HomeFeaturedServiceSelected(serviceId: service.id),
                        );
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}


