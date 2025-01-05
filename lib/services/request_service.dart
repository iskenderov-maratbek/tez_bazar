import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/providers/providers.dart';

class RequestService {
  final Ref ref;

  RequestService(this.ref);

  Future<void> sendRequest<T>(Future<T> Function() request) async {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      ref.read(loadingProvider.notifier).state = true;
      try {
        await request();
        Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
          ref.read(loadingProvider.notifier).state = false;
        });
      } catch (e) {
        logError(e);
        Future.delayed(Duration(seconds: ref.read(loadTimer)), () {
          ref.read(loadingProvider.notifier).state = false;
        });
        // handle error
      }
    });
  }
}
