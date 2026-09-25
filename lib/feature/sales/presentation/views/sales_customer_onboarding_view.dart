import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/customer_registration_cubit.dart';
import 'widgets/sales_customer_onboarding_view_body.dart';

class SalesCustomerOnboardingView extends StatefulWidget {
  final TabController? tabController;
  const SalesCustomerOnboardingView({super.key, this.tabController});

  @override
  State<SalesCustomerOnboardingView> createState() =>
      _SalesCustomerOnboardingViewState();
}

class _SalesCustomerOnboardingViewState
    extends State<SalesCustomerOnboardingView>
    with AutomaticKeepAliveClientMixin {
  late final CustomerRegistrationCubit _registrationCubit;
  bool _isDataFetched = false;

  @override
  void initState() {
    super.initState();
    _registrationCubit = getIt<CustomerRegistrationCubit>();
    
    if (widget.tabController != null) {
      widget.tabController!.addListener(_handleTabSelection);
    } else {
      // If standalone, fetch immediately
      _isDataFetched = true;
      _registrationCubit.fetchAreas();
    }
    
    // Check if it's already selected on start (index 1 for onboarding)
    if (widget.tabController != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleTabSelection();
      });
    }
  }

  void _handleTabSelection() {
    if (!mounted || widget.tabController == null) return;
    
    // index 1 corresponds to 'تسجيل العملاء'
    if (widget.tabController!.index == 1 && !_isDataFetched && !widget.tabController!.indexIsChanging) {
      setState(() {
        _isDataFetched = true;
      });
      _registrationCubit.fetchAreas();
    }
  }

  @override
  void dispose() {
    widget.tabController?.removeListener(_handleTabSelection);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.bgPage,
      body: BlocProvider.value(
        value: _registrationCubit,
        child: const SalesCustomerOnboardingViewBody(),
      ),
    );
  }
}
