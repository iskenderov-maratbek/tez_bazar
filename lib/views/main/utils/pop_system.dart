import 'package:tez_bazar/common/logging.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/providers/providers.dart';

void popSystem(ref, BottomSelectedMenu router) {
  logInfo('PopSystem called');
  final accountState = ref.watch(accountStateProvider);
  final homeState = ref.watch(homeStateProvider);
  switch (router) {
    case BottomSelectedMenu.home:
      switch (homeState) {
        case HomeState.home:
          break;
        case HomeState.category:
          ref.read(appBarTitleProvider.notifier).state =
              TextConstants.homeTitle;
          ref.read(homeStateProvider.notifier).state = HomeState.home;
          break;
        case HomeState.search:
          ref.read(appBarTitleProvider.notifier).state =
              TextConstants.homeTitle;
          ref.read(homeStateProvider.notifier).state = HomeState.home;
          break;
      }
      break;
    case BottomSelectedMenu.userProducts:
      ref.read(routeProvider.notifier).state = BottomSelectedMenu.home;
      break;
    case BottomSelectedMenu.account:
      switch (accountState) {
        case AccountState.account:
          ref.read(routeProvider.notifier).state = BottomSelectedMenu.home;
          break;
        case AccountState.profile:
          ref.read(accountStateProvider.notifier).state = AccountState.account;
          break;
      }
      break;
  }
}
