import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/booking_bloc.dart';
import '../../data/models/booking_model.dart';

class BookingListPage extends StatefulWidget {
  const BookingListPage({super.key});

  @override
  State<BookingListPage> createState() => _BookingListPageState();
}

class _BookingListPageState extends State<BookingListPage> {
  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(const MyBookingsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('حجوزاتي'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              context.read<BookingBloc>().add(const MyBookingsRequested());
            },
          ),
        ],
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
          child: BlocBuilder<BookingBloc, BookingState>(
            builder: (context, state) {
              if (state is BookingLoading) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGolden,
                  ),
                );
              } else if (state is BookingListLoaded) {
                if (state.bookings.isEmpty) {
                  return _buildEmptyState();
                }
                return _buildBookingList(state.bookings);
              } else if (state is BookingError) {
                return _buildErrorState(state.message);
              }
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingXXL),
              decoration: BoxDecoration(
                gradient: AppColors.goldenGradient,
                shape: BoxShape.circle,
                boxShadow: AppColors.goldenShadowMedium,
              ),
              child: const Icon(
                Icons.event_busy,
                size: 64,
                color: AppColors.white,
              ),
            ),
            const SizedBox(height: AppConstants.spacingXXL),
            Text(
              'لا توجد حجوزات',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.primaryGolden,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              'لم تقم بأي حجوزات بعد\nابدأ بحجز خدمات الزفاف المفضلة لديك',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingXXL),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.add),
              label: const Text('إنشاء حجز جديد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGolden,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLG,
                  vertical: AppConstants.spacingMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: AppConstants.spacingLG),
            Text(
              'حدث خطأ',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: AppColors.errorRed,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppConstants.spacingMD),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.spacingXXL),
            ElevatedButton.icon(
              onPressed: () {
                context.read<BookingBloc>().add(const MyBookingsRequested());
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGolden,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.spacingLG,
                  vertical: AppConstants.spacingMD,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Booking> bookings) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<BookingBloc>().add(const MyBookingsRequested());
      },
      color: AppColors.primaryGolden,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppConstants.spacingLG),
        itemCount: bookings.length,
        itemBuilder: (context, index) {
          final booking = bookings[index];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        boxShadow: AppColors.cardShadowMedium,
      ),
      child: InkWell(
        onTap: () => _showBookingDetails(booking),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      booking.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  _buildStatusChip(booking.status),
                ],
              ),
              
              const SizedBox(height: AppConstants.spacingSM),
              
              // Event details
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: AppColors.primaryGolden,
                  ),
                  const SizedBox(width: AppConstants.spacingXS),
                  Text(
                    booking.eventDate,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingMD),
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.primaryGolden,
                  ),
                  const SizedBox(width: AppConstants.spacingXS),
                  Text(
                    booking.timeRange,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: AppConstants.spacingSM),
              
              // Guest count and price
              Row(
                children: [
                  const Icon(
                    Icons.people,
                    size: 16,
                    color: AppColors.primaryGolden,
                  ),
                  const SizedBox(width: AppConstants.spacingXS),
                  Text(
                    '${booking.guestCount} ضيف',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    booking.totalPrice,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGolden,
                    ),
                  ),
                ],
              ),
              
              // Special requests preview
              if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: AppConstants.spacingSM),
                  child: Text(
                    booking.specialRequests!,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color backgroundColor;
    Color textColor;
    String statusText;

    switch (status.toLowerCase()) {
      case 'confirmed':
        backgroundColor = AppColors.successGreen;
        textColor = AppColors.white;
        statusText = 'مؤكد';
        break;
      case 'pending':
        backgroundColor = AppColors.warningOrange;
        textColor = AppColors.white;
        statusText = 'في الانتظار';
        break;
      case 'cancelled':
        backgroundColor = AppColors.errorRed;
        textColor = AppColors.white;
        statusText = 'ملغي';
        break;
      case 'completed':
        backgroundColor = AppColors.primaryGolden;
        textColor = AppColors.white;
        statusText = 'مكتمل';
        break;
      default:
        backgroundColor = AppColors.lightGray;
        textColor = AppColors.textSecondary;
        statusText = status;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingSM,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusSmall),
      ),
      child: Text(
        statusText,
        style: TextStyle(
          color: textColor,
          fontSize: AppConstants.fontSizeXS,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  void _showBookingDetails(Booking booking) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppConstants.borderRadiusLarge),
            ),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(AppConstants.spacingLG),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.borderGray,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingLG),
                
                // Title
                Text(
                  booking.title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                
                const SizedBox(height: AppConstants.spacingMD),
                
                // Status and payment status
                Row(
                  children: [
                    _buildStatusChip(booking.status),
                    const SizedBox(width: AppConstants.spacingSM),
                    _buildStatusChip(booking.paymentStatus),
                  ],
                ),
                
                const SizedBox(height: AppConstants.spacingLG),
                
                // Event details
                _buildDetailRow(
                  icon: Icons.calendar_today,
                  label: 'التاريخ',
                  value: booking.eventDate,
                ),
                
                _buildDetailRow(
                  icon: Icons.access_time,
                  label: 'الوقت',
                  value: booking.timeRange,
                ),
                
                _buildDetailRow(
                  icon: Icons.people,
                  label: 'عدد الضيوف',
                  value: '${booking.guestCount} ضيف',
                ),
                
                _buildDetailRow(
                  icon: Icons.attach_money,
                  label: 'السعر الإجمالي',
                  value: booking.totalPrice,
                ),
                
                // Special requests
                if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppConstants.spacingLG),
                      Text(
                        'الطلبات الخاصة',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingSM),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppConstants.spacingMD),
                        decoration: BoxDecoration(
                          color: AppColors.lightGray,
                          borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                        ),
                        child: Text(
                          booking.specialRequests!,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                
                const SizedBox(height: AppConstants.spacingXXL),
                
                // Action buttons
                Row(
                  children: [
                    if (booking.status == 'pending')
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () => _cancelBooking(booking.id),
                          icon: const Icon(Icons.cancel),
                          label: const Text('إلغاء الحجز'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.errorRed,
                            foregroundColor: AppColors.white,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spacingMD,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                            ),
                          ),
                        ),
                      ),
                    if (booking.status == 'pending')
                      const SizedBox(width: AppConstants.spacingMD),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close),
                        label: const Text('إغلاق'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGolden,
                          foregroundColor: AppColors.white,
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingMD,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(AppConstants.borderRadius),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingMD),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: AppColors.primaryGolden,
          ),
          const SizedBox(width: AppConstants.spacingSM),
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _cancelBooking(String bookingId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء الحجز'),
        content: const Text('هل أنت متأكد من إلغاء هذا الحجز؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<BookingBloc>().add(
                BookingCancelRequested(bookingId: int.parse(bookingId)),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorRed,
              foregroundColor: AppColors.white,
            ),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
  }
}
