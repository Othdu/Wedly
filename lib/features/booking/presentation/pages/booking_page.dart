import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../bloc/booking_bloc.dart';

class BookingPage extends StatefulWidget {
  final String? serviceId;
  final String? hallId;

  const BookingPage({super.key, this.serviceId, this.hallId});

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _guestCountController = TextEditingController(text: '50');
  final _specialRequestsController = TextEditingController();
  final _notesController = TextEditingController();

  DateTime? _selectedDate = DateTime.now().add(const Duration(days: 30));
  TimeOfDay? _startTime = const TimeOfDay(hour: 18, minute: 0);
  TimeOfDay? _endTime = const TimeOfDay(hour: 23, minute: 0);
  int _stepIndex = 0;

  @override
  void dispose() {
    _guestCountController.dispose();
    _specialRequestsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  Future<void> _pickStartTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _startTime!,
    );
    if (picked != null) setState(() => _startTime = picked);
  }

  Future<void> _pickEndTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _endTime!,
    );
    if (picked != null) setState(() => _endTime = picked);
  }

  void _nextStep() {
    if (_stepIndex < 3) setState(() => _stepIndex++);
    else _submitBooking();
  }

  void _prevStep() {
    if (_stepIndex > 0) setState(() => _stepIndex--);
    else Navigator.pop(context);
  }

  void _submitBooking() {
    if (!_formKey.currentState!.validate()) return;

    final eventDate = _selectedDate!;
    final start = DateTime(eventDate.year, eventDate.month, eventDate.day, _startTime!.hour, _startTime!.minute);
    final end = DateTime(eventDate.year, eventDate.month, eventDate.day, _endTime!.hour, _endTime!.minute);

    context.read<BookingBloc>().add(BookingCreateRequested(
      hallId: widget.hallId != null ? int.tryParse(widget.hallId!) : null,
      serviceId: widget.serviceId != null ? int.tryParse(widget.serviceId!) : null,
      eventDate: eventDate,
      startTime: start,
      endTime: end,
      guestCount: int.parse(_guestCountController.text),
      specialRequests: _specialRequestsController.text.isNotEmpty ? _specialRequestsController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      _buildDateStep(),
      _buildTimeStep(),
      _buildGuestStep(),
      _buildDetailsStep(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'حجز جديد',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primaryGolden,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: BlocListener<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: const Text('تم إنشاء الحجز بنجاح'), backgroundColor: AppColors.successGreen),
            );
            Navigator.pop(context);
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: AppColors.errorRed),
            );
          }
        },
        child: Column(
          children: [
            _buildProgressHeader(),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                transitionBuilder: (child, anim) => FadeTransition(opacity: anim, child: child),
                child: Form(
                  key: _formKey,
                  child: Padding(
                    key: ValueKey(_stepIndex),
                    padding: const EdgeInsets.all(AppConstants.spacingXL),
                    child: steps[_stepIndex],
                  ),
                ),
              ),
            ),
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppConstants.spacingLG, horizontal: AppConstants.spacingXL),
      decoration: BoxDecoration(
        color: AppColors.primaryGolden,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildStepCircle(0, 'تاريخ'),
          _buildConnectorLine(0),
          _buildStepCircle(1, 'وقت'),
          _buildConnectorLine(1),
          _buildStepCircle(2, 'ضيوف'),
          _buildConnectorLine(2),
          _buildStepCircle(3, 'تفاصيل'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isCompleted = step < _stepIndex;
    final isCurrent = step == _stepIndex;
    
    return Column(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? AppColors.white : (isCurrent ? AppColors.white.withOpacity(0.9) : AppColors.white.withOpacity(0.3)),
            border: Border.all(
              color: AppColors.white,
              width: isCurrent ? 3 : 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: AppColors.primaryGolden, size: 20)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      color: isCurrent ? AppColors.primaryGolden : AppColors.primaryGolden.withOpacity(0.5),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            color: AppColors.white,
            fontSize: 12,
            fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }

  Widget _buildConnectorLine(int step) {
    final isCompleted = step < _stepIndex;
    
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 28),
        color: isCompleted ? AppColors.white : AppColors.white.withOpacity(0.3),
      ),
    );
  }

  Widget _buildDateStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.calendar_month, 'تاريخ الحدث'),
        const SizedBox(height: 12),
        _dateCard(_selectedDate!, _pickDate),
      ],
    );
  }

  Widget _buildTimeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.access_time, 'تحديد الوقت'),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _timeCard('وقت البداية', _startTime!, _pickStartTime)),
            const SizedBox(width: 12),
            Expanded(child: _timeCard('وقت النهاية', _endTime!, _pickEndTime)),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.people, 'عدد الضيوف'),
        const SizedBox(height: 12),
        TextFormField(
          controller: _guestCountController,
          keyboardType: TextInputType.number,
          textCapitalization: TextCapitalization.none,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          decoration: _inputDecoration('أدخل عدد الضيوف'),
          validator: (v) {
            final n = int.tryParse(v ?? '');
            if (n == null || n < 1) return 'يرجى إدخال عدد صحيح أكبر من 0';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionTitle(Icons.note_alt, 'تفاصيل إضافية'),
        const SizedBox(height: 12),
        TextFormField(
          controller: _specialRequestsController,
          maxLines: 3,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.next,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          decoration: _inputDecoration('طلبات خاصة (اختياري)'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: _notesController,
          maxLines: 2,
          textCapitalization: TextCapitalization.sentences,
          textInputAction: TextInputAction.done,
          autocorrect: false,
          enableSuggestions: false,
          smartDashesType: SmartDashesType.disabled,
          smartQuotesType: SmartQuotesType.disabled,
          decoration: _inputDecoration('ملاحظات إضافية (اختياري)'),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLG),
      color: Colors.white,
      child: Row(
        children: [
          if (_stepIndex > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _prevStep,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.borderGray, width: 2),
                ),
                child: const Text('رجوع'),
              ),
            ),
          if (_stepIndex > 0) const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: ElevatedButton(
              onPressed: _nextStep,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGolden,
                foregroundColor: AppColors.white,
                padding: const EdgeInsets.symmetric(vertical: 18),
              ),
              child: Text(_stepIndex < 3 ? 'التالي' : 'إنهاء'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _sectionTitle(IconData icon, String title) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryGolden),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }

  Widget _dateCard(DateTime date, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.primaryGolden),
              const SizedBox(width: 16),
              Text('${date.day}/${date.month}/${date.year}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              const Spacer(),
              const Icon(Icons.edit_calendar, color: AppColors.primaryGolden),
            ],
          ),
        ),
      ),
    );
  }

  Widget _timeCard(String label, TimeOfDay time, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
                  style: const TextStyle(fontSize: 18, color: AppColors.primaryGolden)),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: AppColors.lightGray.withOpacity(0.3),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: AppColors.primaryGolden, width: 2),
      ),
    );
  }
}
