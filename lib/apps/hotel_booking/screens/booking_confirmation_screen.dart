import 'package:flutter/material.dart';
import '../models/booking.dart';

class BookingConfirmationScreen extends StatefulWidget {
  final Booking booking;

  const BookingConfirmationScreen({
    super.key,
    required this.booking,
  });

  @override
  State<BookingConfirmationScreen> createState() => _BookingConfirmationScreenState();
}

class _BookingConfirmationScreenState extends State<BookingConfirmationScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _confettiController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.2, 0.8, curve: Curves.elasticOut),
    ));

    _slideAnimation = Tween<double>(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.4, 1.0, curve: Curves.easeOutCubic),
    ));

    _animationController.forward();
    _confettiController.repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date, bool isArabic) {
    final months = isArabic 
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
           'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final month = months[date.month - 1];
    final day = date.day;
    final year = date.year;
    
    if (isArabic) {
      return '$day $month $year';
    } else {
      return '$month $day, $year';
    }
  }

  void _goBackToHome() {
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Stack(
          children: [
            // Confetti Background
            AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: ConfettiPainter(_confettiController.value),
                  size: Size.infinite,
                );
              },
            ),
            
            // Content
            SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  
                  // Success Icon
                  ScaleTransition(
                    scale: _scaleAnimation,
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 60,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Success Message
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Column(
                      children: [
                        Text(
                          isArabic ? 'تم الحجز بنجاح!' : 'Booking Confirmed!',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic 
                              ? 'تم تأكيد حجزك بنجاح. ستصلك رسالة تأكيد على البريد الإلكتروني.'
                              : 'Your booking has been confirmed successfully. You will receive a confirmation email shortly.',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                            height: 1.5,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Booking Details Card
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 15,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Booking ID
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF667eea).withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    isArabic ? 'رقم الحجز: ${widget.booking.id}' : 'Booking ID: ${widget.booking.id}',
                                    style: const TextStyle(
                                      color: Color(0xFF667eea),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                
                                const SizedBox(height: 20),
                                
                                // Hotel Information
                                Row(
                                  children: [
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        gradient: const LinearGradient(
                                          colors: [Color(0xFF667eea), Color(0xFF764ba2)],
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.hotel,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.booking.hotelName,
                                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            isArabic ? 'حجز فندق مؤكد' : 'Hotel Booking Confirmed',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Guest Information
                                _buildInfoSection(
                                  isArabic ? 'معلومات الضيف' : 'Guest Information',
                                  [
                                    _buildInfoRow(
                                      isArabic ? 'الاسم' : 'Name',
                                      widget.booking.guestName,
                                      Icons.person,
                                    ),
                                    _buildInfoRow(
                                      isArabic ? 'البريد الإلكتروني' : 'Email',
                                      widget.booking.guestEmail,
                                      Icons.email,
                                    ),
                                    _buildInfoRow(
                                      isArabic ? 'الهاتف' : 'Phone',
                                      widget.booking.guestPhone,
                                      Icons.phone,
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Booking Details
                                _buildInfoSection(
                                  isArabic ? 'تفاصيل الحجز' : 'Booking Details',
                                  [
                                    _buildInfoRow(
                                      isArabic ? 'تاريخ الوصول' : 'Check-in Date',
                                      _formatDate(widget.booking.checkInDate, isArabic),
                                      Icons.calendar_today,
                                    ),
                                    _buildInfoRow(
                                      isArabic ? 'تاريخ المغادرة' : 'Check-out Date',
                                      _formatDate(widget.booking.checkOutDate, isArabic),
                                      Icons.calendar_today,
                                    ),
                                    _buildInfoRow(
                                      isArabic ? 'عدد الليالي' : 'Number of Nights',
                                      '${widget.booking.numberOfNights}',
                                      Icons.nights_stay,
                                    ),
                                    _buildInfoRow(
                                      isArabic ? 'عدد الضيوف' : 'Number of Guests',
                                      '${widget.booking.numberOfGuests}',
                                      Icons.people,
                                    ),
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Room Information
                                _buildInfoSection(
                                  isArabic ? 'معلومات الغرفة' : 'Room Information',
                                  [
                                    for (final room in widget.booking.rooms) ...[
                                      _buildInfoRow(
                                        isArabic ? 'نوع الغرفة' : 'Room Type',
                                        room.roomName,
                                        Icons.bed,
                                      ),
                                      _buildInfoRow(
                                        isArabic ? 'الكمية' : 'Quantity',
                                        '${room.quantity}',
                                        Icons.numbers,
                                      ),
                                      _buildInfoRow(
                                        isArabic ? 'السعر لكل ليلة' : 'Price per Night',
                                        '\$${room.pricePerNight}',
                                        Icons.attach_money,
                                      ),
                                    ],
                                  ],
                                ),
                                
                                const SizedBox(height: 24),
                                
                                // Total Amount
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        const Color(0xFF667eea).withOpacity(0.1),
                                        const Color(0xFF764ba2).withOpacity(0.1),
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        isArabic ? 'المجموع الكلي' : 'Total Amount',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        '\$${widget.booking.totalAmount.toStringAsFixed(2)}',
                                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF667eea),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Action Buttons
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: AnimatedBuilder(
                      animation: _slideAnimation,
                      builder: (context, child) {
                        return Transform.translate(
                          offset: Offset(0, _slideAnimation.value + 20),
                          child: Column(
                            children: [
                              // Back to Home Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: ElevatedButton.icon(
                                  onPressed: _goBackToHome,
                                  icon: const Icon(Icons.home),
                                  label: Text(
                                    isArabic ? 'العودة للرئيسية' : 'Back to Home',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF667eea),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    elevation: 4,
                                  ),
                                ),
                              ),
                              
                              const SizedBox(height: 12),
                              
                              // Share Booking Button
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton.icon(
                                  onPressed: () {
                                    // TODO: Implement share functionality
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          isArabic ? 'تم نسخ تفاصيل الحجز' : 'Booking details copied',
                                        ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.share),
                                  label: Text(
                                    isArabic ? 'مشاركة الحجز' : 'Share Booking',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: const Color(0xFF667eea),
                                    side: const BorderSide(color: Color(0xFF667eea)),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF667eea),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            icon,
            size: 16,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ConfettiPainter extends CustomPainter {
  final double animationValue;

  ConfettiPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
    ];

    for (int i = 0; i < 50; i++) {
      final x = (i * 37.0 + animationValue * 100) % size.width;
      final y = (i * 23.0 + animationValue * 200) % size.height;
      
      paint.color = colors[i % colors.length].withOpacity(0.6);
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(animationValue * 6.28 + i);
      
      // Draw different shapes
      if (i % 3 == 0) {
        // Rectangle
        canvas.drawRect(const Rect.fromLTWH(-2, -2, 4, 4), paint);
      } else if (i % 3 == 1) {
        // Circle
        canvas.drawCircle(Offset.zero, 2, paint);
      } else {
        // Triangle
        final path = Path()
          ..moveTo(0, -3)
          ..lineTo(-2, 2)
          ..lineTo(2, 2)
          ..close();
        canvas.drawPath(path, paint);
      }
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
