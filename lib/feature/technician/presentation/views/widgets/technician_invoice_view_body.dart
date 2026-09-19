import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import 'product_item_card.dart';

class TechnicianInvoiceViewBody extends StatefulWidget {
  const TechnicianInvoiceViewBody({super.key});

  @override
  State<TechnicianInvoiceViewBody> createState() => _TechnicianInvoiceViewBodyState();
}

class _TechnicianInvoiceViewBodyState extends State<TechnicianInvoiceViewBody> {
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  final int _pageSize = 5;
  bool _isLoading = false;
  String _selectedFilter = 'الكل';

  final List<Map<String, dynamic>> _allDummyProducts = [
    {'name': 'مكثف ضاغط التكييف', 'price': 320.0, 'availableCount': 5, 'isLowStock': false},
    {'name': 'غاز تبريد (R410A)', 'price': 480.0, 'availableCount': 8, 'isLowStock': false},
    {'name': 'طقم مواسير نحاس', 'price': 260.0, 'availableCount': 3, 'isLowStock': false},
    {'name': 'فلتر هواء (HEPA)', 'price': 150.0, 'availableCount': 12, 'isLowStock': false},
    {'name': 'وحدة تحكم ثرموستات', 'price': 640.0, 'availableCount': 2, 'isLowStock': true},
    {'name': 'مفتاح كهرباء ثلاثي', 'price': 90.0, 'availableCount': 15, 'isLowStock': false},
    {'name': 'محرك مروحة خارجية', 'price': 850.0, 'availableCount': 4, 'isLowStock': false},
    {'name': 'شريط عازل حراري', 'price': 45.0, 'availableCount': 20, 'isLowStock': false},
    {'name': 'صمام تمدد حراري', 'price': 410.0, 'availableCount': 1, 'isLowStock': true},
    {'name': 'حامل حديد للمكيف', 'price': 180.0, 'availableCount': 7, 'isLowStock': false},
  ];

  List<Map<String, dynamic>> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _allDummyProducts.where((product) {
      final matchesSearch = product['name'].toString().toLowerCase().contains(query);
      bool matchesFilter = true;
      if (_selectedFilter == 'مخزون منخفض') {
        matchesFilter = product['isLowStock'] == true;
      } else if (_selectedFilter == 'متوفر') {
        matchesFilter = (product['availableCount'] as int) > 0;
      }
      return matchesSearch && matchesFilter;
    }).toList();
  }

  int get _totalPages {
    final count = _filteredProducts.length;
    if (count == 0) return 1;
    return (count / _pageSize).ceil();
  }

  List<Map<String, dynamic>> get _currentPageProducts {
    final filtered = _filteredProducts;
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = startIndex + _pageSize;
    if (startIndex >= filtered.length) return [];
    return filtered.sublist(
      startIndex,
      endIndex > filtered.length ? filtered.length : endIndex,
    );
  }

  void _goToPage(int page) {
    if (page < 1 || page > _totalPages || page == _currentPage) return;
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 200), () {
      if (mounted) {
        setState(() {
          _currentPage = page;
          _isLoading = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentProducts = _currentPageProducts;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'المنتجات والفاتورة',
              style: AppStyle.headingLarge,
            ),
            const SizedBox(height: 4),
            const Text(
              'اختر قطع الغيار وأكّد استلام المبلغ.',
              style: AppStyle.bodySmall,
            ),
            const SizedBox(height: 16),
            _buildSearchAndFilterBar(),
            const SizedBox(height: 16),
            if (_isLoading)
              const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              )
            else if (currentProducts.isEmpty)
              const SizedBox(
                height: 150,
                child: Center(
                  child: Text('لا توجد نتائج مطابقة للبحث', style: AppStyle.bodySmall),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: currentProducts.length,
                itemBuilder: (context, index) {
                  final item = currentProducts[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: ProductItemCard(
                      name: item['name'] as String,
                      price: (item['price'] as num).toDouble(),
                      availableCount: item['availableCount'] as int,
                      isLowStock: item['isLowStock'] ?? false,
                    ),
                  );
                },
              ),
            const SizedBox(height: 16),
            if (_filteredProducts.isNotEmpty) _buildPaginationBar(),
            const SizedBox(height: 16),
            const InvoiceSummaryCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            color: AppColors.bgPage,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.borderSubtle),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedFilter,
              dropdownColor: AppColors.bgPage,
              icon: const Icon(Icons.filter_list, size: 20, color: AppColors.textMuted),
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    _selectedFilter = newValue;
                    _currentPage = 1;
                  });
                }
              },
              items: <String>['الكل', 'متوفر', 'مخزون منخفض']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value, style: AppStyle.labelSmall),
                );
              }).toList(),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: TextField(
            controller: _searchController,
            textAlign: TextAlign.right,
            onChanged: (value) {
              setState(() {
                _currentPage = 1;
              });
            },
            decoration: InputDecoration(
              hintText: 'ابحث عن قطعة غيار...',
              hintStyle: AppStyle.hint,
              prefixIcon: const Icon(Icons.search, size: 20, color: AppColors.textMuted),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, size: 18),
                      onPressed: () {
                        _searchController.clear();
                        setState(() => _currentPage = 1);
                      },
                    )
                  : null,
              filled: true,
              fillColor: AppColors.bgCard,
              contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.borderSubtle),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: AppColors.primary),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPaginationBar() {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _currentPage > 1 ? () => _goToPage(_currentPage - 1) : null,
            icon: const Icon(Icons.chevron_left),
          ),
          const SizedBox(width: 4),
          Row(
            children: List.generate(_totalPages, (index) {
              final pageNum = index + 1;
              final isSelected = pageNum == _currentPage;

              return InkWell(
                onTap: () => _goToPage(pageNum),
                borderRadius: BorderRadius.circular(6),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary : Colors.transparent,
                    borderRadius: BorderRadius.circular(6),
                    border: isSelected ? null : Border.all(color: AppColors.borderSubtle),
                  ),
                  child: Center(
                    child: Text(
                      '$pageNum',
                      style: AppStyle.labelMedium.copyWith(
                        color: isSelected ? Colors.white : AppColors.textHeading,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(width: 4),
          IconButton(
            onPressed: _currentPage < _totalPages ? () => _goToPage(_currentPage + 1) : null,
            icon: const Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
