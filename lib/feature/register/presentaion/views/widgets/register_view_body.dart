import 'package:flutter/material.dart';
import 'customer_details_card.dart';
import 'phone_search_card.dart';
import 'register_header.dart';

class RegisterViewBody extends StatelessWidget {
  const RegisterViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: const Column(
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
