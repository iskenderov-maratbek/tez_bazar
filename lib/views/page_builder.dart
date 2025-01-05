import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/app_colors.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/services/refresh_service.dart';

class PageBuilder extends ConsumerStatefulWidget {
  final Widget child;
  final Future<void> Function()? onRefresh;
  const PageBuilder({
    super.key,
    required this.child,
    this.onRefresh,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PageBuilderState();
}

class _PageBuilderState extends ConsumerState<PageBuilder> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      strokeWidth: 2,
      color: AppColors.primaryColor,
      backgroundColor: AppColors.black,
      onRefresh: () async {
        logInfo('Refreshing');
        widget.onRefresh != null
            ? ref.read(refreshServiceProvider.notifier).refresh(() async {
                await widget.onRefresh!();
              })
            : null;
      },
      child: widget.child,
    );
  }
}
