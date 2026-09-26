import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/service_locator.dart';
import '../manager/maintenance_cubit.dart';
import 'widgets/maintenance_tab_body.dart';

class MaintenanceTabView extends StatefulWidget {
  final TabController? controller;
  const MaintenanceTabView({super.key, this.controller});

  @override
  State<MaintenanceTabView> createState() => _MaintenanceTabViewState();
}

class _MaintenanceTabViewState extends State<MaintenanceTabView>
    with AutomaticKeepAliveClientMixin {
  late final MaintenanceCubit _maintenanceCubit;
  bool _isDataFetched = false;

  @override
  void initState() {
    super.initState();
    _maintenanceCubit = getIt<MaintenanceCubit>();

    if (widget.controller != null) {
      widget.controller!.addListener(_handleTabSelection);
    } else {
      _isDataFetched = true;
      _maintenanceCubit.getAssignedMaintenance();
    }

    if (widget.controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _handleTabSelection();
      });
    }
  }

  void _handleTabSelection() {
    if (!mounted || widget.controller == null) return;

    if (widget.controller!.index == 0 &&
        !_isDataFetched &&
        !widget.controller!.indexIsChanging) {
      setState(() {
        _isDataFetched = true;
      });
      _maintenanceCubit.getAssignedMaintenance();
    }
  }

  @override
  void dispose() {
    widget.controller?.removeListener(_handleTabSelection);
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return BlocProvider.value(
      value: _maintenanceCubit,
      child: Scaffold(
          backgroundColor: AppColors.bgPage,
          body: const MaintenanceTabBody()),
    );
  }
}
