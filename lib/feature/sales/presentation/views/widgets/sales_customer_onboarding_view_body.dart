import 'package:flutter/material.dart';
import 'customer_details_card.dart';
import 'phone_search_card.dart';
import 'register_header.dart';

class SalesCustomerOnboardingViewBody extends StatelessWidget {
  const SalesCustomerOnboardingViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            RegisterHeader(),
            SizedBox(height: 16),
            PhoneSearchCard(),
            SizedBox(height: 16),
            CustomerDetailsCard(),
          ],
        ),
      ),
    );
  }
}
