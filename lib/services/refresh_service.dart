import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/logging.dart';

class RefreshService extends StateNotifier<bool> {
  Ref ref;
  RefreshService(this.ref) : super(false);

  Future<void> refresh(Function? refreshData) async {
    logInfo('Refresh service called');
    state = true;
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      refreshData != null ? await refreshData() : null;
    });
    Future.delayed(const Duration(seconds: 3), () {
      state = false;
    });
  }
}

final refreshServiceProvider =
    StateNotifierProvider<RefreshService, bool>((ref) {
  return RefreshService(ref);
});
