import 'package:flutter/material.dart';
import '../models/hotel.dart';
import '../models/booking.dart';
import '../widgets/hotel_card.dart';

class SearchHotelsScreen extends StatefulWidget {
  final VoidCallback onLanguageToggle;
  final VoidCallback onThemeToggle;
  final bool isDarkMode;
  final Function(SearchCriteria) onSearchSubmitted;

  const SearchHotelsScreen({
    super.key,
    required this.onLanguageToggle,
    required this.onThemeToggle,
    required this.isDarkMode,
    required this.onSearchSubmitted,
  });

  @override
  State<SearchHotelsScreen> createState() => _SearchHotelsScreenState();
}

class _SearchHotelsScreenState extends State<SearchHotelsScreen>
    with TickerProviderStateMixin {
  final _destinationController = TextEditingController();
  DateTime _checkInDate = DateTime.now().add(const Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(const Duration(days: 3));
  int _numberOfGuests = 2;
  int _numberOfRooms = 1;
  
  List<Hotel> _searchResults = [];
  bool _isSearching = false;
  bool _hasSearched = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.forward();
    
    // Load all hotels initially
    _searchResults = Hotel.getDummyHotels();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _destinationController.dispose();
    super.dispose();
  }

  Future<void> _selectCheckInDate() async {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkInDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: isArabic ? 'اختر تاريخ الوصول' : 'Select Check-in Date',
      cancelText: isArabic ? 'إلغاء' : 'Cancel',
      confirmText: isArabic ? 'موافق' : 'OK',
    );

    if (picked != null) {
      setState(() {
        _checkInDate = picked;
        // Ensure check-out is after check-in
        if (_checkOutDate.isBefore(_checkInDate.add(const Duration(days: 1)))) {
          _checkOutDate = _checkInDate.add(const Duration(days: 1));
        }
      });
    }
  }

  Future<void> _selectCheckOutDate() async {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';
    
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _checkOutDate,
      firstDate: _checkInDate.add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      helpText: isArabic ? 'اختر تاريخ المغادرة' : 'Select Check-out Date',
      cancelText: isArabic ? 'إلغاء' : 'Cancel',
      confirmText: isArabic ? 'موافق' : 'OK',
    );

    if (picked != null && picked != _checkOutDate) {
      setState(() {
        _checkOutDate = picked;
      });
    }
  }

  String _formatDate(DateTime date, bool isArabic) {
    final months = isArabic 
        ? ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
           'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر']
        : ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
           'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final month = months[date.month - 1];
    final day = date.day;
    
    if (isArabic) {
      return '$day $month';
    } else {
      return '$month $day';
    }
  }

  void _performSearch() async {
    if (_destinationController.text.trim().isEmpty) {
      final locale = Localizations.localeOf(context);
      final isArabic = locale.languageCode == 'ar';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isArabic ? 'يرجى إدخال الوجهة' : 'Please enter destination',
          ),
        ),
      );
      return;
    }

    setState(() {
      _isSearching = true;
    });

    // Create search criteria
    final searchCriteria = SearchCriteria(
      destination: _destinationController.text.trim(),
      checkInDate: _checkInDate,
      checkOutDate: _checkOutDate,
      numberOfGuests: _numberOfGuests,
      numberOfRooms: _numberOfRooms,
    );

    widget.onSearchSubmitted(searchCriteria);

    // Simulate search delay
    await Future.delayed(const Duration(seconds: 1));

    // Filter hotels based on destination (simple string matching)
    final filteredHotels = Hotel.getDummyHotels().where((hotel) {
      return hotel.city.toLowerCase().contains(_destinationController.text.toLowerCase()) ||
             hotel.name.toLowerCase().contains(_destinationController.text.toLowerCase());
    }).toList();

    setState(() {
      _searchResults = filteredHotels.isNotEmpty ? filteredHotels : Hotel.getDummyHotels();
      _isSearching = false;
      _hasSearched = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isArabic = locale.languageCode == 'ar';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            floating: false,
            pinned: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
            automaticallyImplyLeading: false,
            actions: [
              IconButton(
                onPressed: widget.onLanguageToggle,
                icon: const Icon(Icons.language, color: Colors.white),
              ),
              IconButton(
                onPressed: widget.onThemeToggle,
                icon: Icon(
                  widget.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: Colors.white,
                ),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                isArabic ? 'البحث عن فندق' : 'Search Hotels',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 6,
                    ),
                  ],
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xFF667eea),
                      Color(0xFF764ba2),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      Icon(
                        Icons.hotel,
                        size: 60,
                        color: Colors.white.withOpacity(0.9),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isArabic ? 'اكتشف أفضل الفنادق' : 'Discover Amazing Hotels',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          
          // Search Form
          SliverToBoxAdapter(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Destination
                    Text(
                      isArabic ? 'الوجهة' : 'Destination',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _destinationController,
                      textAlign: isArabic ? TextAlign.right : TextAlign.left,
                      decoration: InputDecoration(
                        hintText: isArabic ? 'أين تريد الإقامة؟' : 'Where do you want to stay?',
                        prefixIcon: const Icon(Icons.location_on, color: Color(0xFF667eea)),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Color(0xFF667eea)),
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Check-in and Check-out Dates
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'تاريخ الوصول' : 'Check-in',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _selectCheckInDate,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: Color(0xFF667eea)),
                                      const SizedBox(width: 8),
                                      Text(_formatDate(_checkInDate, isArabic)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'تاريخ المغادرة' : 'Check-out',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: _selectCheckOutDate,
                                child: Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey[300]!),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.calendar_today, color: Color(0xFF667eea)),
                                      const SizedBox(width: 8),
                                      Text(_formatDate(_checkOutDate, isArabic)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Guests and Rooms
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'عدد الضيوف' : 'Guests',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: _numberOfGuests > 1 ? () {
                                        setState(() {
                                          _numberOfGuests--;
                                        });
                                      } : null,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$_numberOfGuests',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _numberOfGuests++;
                                        });
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isArabic ? 'عدد الغرف' : 'Rooms',
                                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey[300]!),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      onPressed: _numberOfRooms > 1 ? () {
                                        setState(() {
                                          _numberOfRooms--;
                                        });
                                      } : null,
                                      icon: const Icon(Icons.remove),
                                    ),
                                    Expanded(
                                      child: Text(
                                        '$_numberOfRooms',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _numberOfRooms++;
                                        });
                                      },
                                      icon: const Icon(Icons.add),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Search Button
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        onPressed: _isSearching ? null : _performSearch,
                        icon: _isSearching 
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.search),
                        label: Text(
                          _isSearching 
                              ? (isArabic ? 'جاري البحث...' : 'Searching...')
                              : (isArabic ? 'البحث عن الفنادق' : 'Search Hotels'),
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
                  ],
                ),
              ),
            ),
          ),
          
          // Search Results Header
          if (_hasSearched) ...[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Text(
                      isArabic ? 'النتائج:' : 'Results:',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF667eea).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_searchResults.length}',
                        style: const TextStyle(
                          color: Color(0xFF667eea),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
          
          // Hotels List
          _searchResults.isEmpty && _hasSearched
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        Icon(
                          Icons.hotel_outlined,
                          size: 80,
                          color: Colors.grey[300],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          isArabic ? 'لم يتم العثور على فنادق' : 'No hotels found',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Colors.grey[500],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          isArabic 
                              ? 'جرب البحث بوجهة أخرى'
                              : 'Try searching with a different destination',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      ],
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final hotel = _searchResults[index];
                        return FadeTransition(
                          opacity: _fadeAnimation,
                          child: HotelCard(
                            hotel: hotel,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/hotel-details',
                                arguments: {'hotel': hotel},
                              );
                            },
                            searchCriteria: SearchCriteria(
                              destination: _destinationController.text.trim(),
                              checkInDate: _checkInDate,
                              checkOutDate: _checkOutDate,
                              numberOfGuests: _numberOfGuests,
                              numberOfRooms: _numberOfRooms,
                            ),
                          ),
                        );
                      },
                      childCount: _searchResults.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
