import 'package:flutter/material.dart';
import '../../../../../core/utils/app_colors.dart';
import '../../../../../core/utils/app_style.dart';
import 'archive_invoice_card.dart';

class TechnicianArchiveViewBody extends StatefulWidget {
  const TechnicianArchiveViewBody({super.key});

  @override
  State<TechnicianArchiveViewBody> createState() => _TechnicianArchiveViewBodyState();
}

class _TechnicianArchiveViewBodyState extends State<TechnicianArchiveViewBody> {
  String _selectedFilter = 'الكل';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _allInvoices = [
    {
      'customerName': 'أميرة حسن',
      'orderId': 'JO-8790',
      'date': '14 سبتمبر',
      'price': '1,240 ج.م',
      'area': 'التجمع الخامس',
      'isConfirmed': true,
    },
    {
      'customerName': 'يوسف عادل',
      'orderId': 'JO-8788',
      'date': '14 سبتمبر',
      'price': '680 ج.م',
      'area': 'المعادي',
      'isConfirmed': false,
    },
    {
      'customerName': 'سلمى فاروق',
      'orderId': 'JO-8781',
      'date': '13 سبتمبر',
      'price': '1,590 ج.م',
      'area': '6 أكتوبر',
      'isConfirmed': true,
    },
    {
      'customerName': 'كريم نبيل',
      'orderId': 'JO-8775',
      'date': '12 سبتمبر',
      'price': '430 ج.م',
      'area': 'مدينة نصر',
      'isConfirmed': false,
    },
  ];

  List<Map<String, dynamic>> get _filteredInvoices {
    return _allInvoices.where((invoice) {
      bool matchesFilter = true;
      if (_selectedFilter == 'مؤكدة') {
        matchesFilter = invoice['isConfirmed'] == true;
      } else if (_selectedFilter == 'قيد التأكيد') {
        matchesFilter = invoice['isConfirmed'] == false;
      }

      final query = _searchQuery.trim().toLowerCase();
      final matchesSearch = query.isEmpty ||
          invoice['customerName'].toString().toLowerCase().contains(query) ||
          invoice['orderId'].toString().toLowerCase().contains(query);

      return matchesFilter && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filteredList = _filteredInvoices;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text(
              'أرشيف الفواتير',
              style: AppStyle.headingLarge,
            ),
            const SizedBox(height: 4),
            const Text(
              'الأوردرات المنتهية وحالة تأكيد المحاسب.',
              style: AppStyle.bodySmall,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              textAlign: TextAlign.right,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث برقم الأوردر أو اسم العميل',
                hintStyle: AppStyle.hint,
                prefixIcon: const Icon(Icons.search, color: AppColors.textMuted),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                fillColor: AppColors.bgCard,
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.borderSubtle),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primary),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _buildFilterChip('مؤكدة'),
                const SizedBox(width: 8),
                _buildFilterChip('قيد التأكيد'),
                const SizedBox(width: 8),
                _buildFilterChip('الكل'),
              ],
            ),
            const SizedBox(height: 16),
            if (filteredList.isEmpty)
              const SizedBox(
                height: 200,
                child: Center(
                  child: Text(
                    'لا توجد فواتير مطابقة للبحث',
                    style: AppStyle.bodySmall,
                  ),
                ),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredList.length,
                separatorBuilder: (context, index) => const SizedBox(height: 10),
                itemBuilder: (context, index) {
                  final item = filteredList[index];
                  return ArchiveInvoiceCard(
                    customerName: item['customerName'] as String,
                    orderId: item['orderId'] as String,
                    date: item['date'] as String,
                    price: item['price'] as String,
                    area: item['area'] as String,
                    isConfirmed: item['isConfirmed'] as bool,
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    final isSelected = _selectedFilter == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFilter = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.bgCard,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.borderSubtle,
          ),
        ),
        child: Text(
          label,
          style: AppStyle.labelMedium.copyWith(
            fontSize: 12,
            color: isSelected ? Colors.white : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
