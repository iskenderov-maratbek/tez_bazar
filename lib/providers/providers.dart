import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tez_bazar/models/archive_products.dart';
import 'package:tez_bazar/models/banners.dart';
import 'package:tez_bazar/models/user_products.dart';

import 'package:tez_bazar/models/categories.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:tez_bazar/models/search_history.dart';
import 'package:tez_bazar/products_services/archive_products_service.dart';
import 'package:tez_bazar/products_services/banners_service.dart';
import 'package:tez_bazar/products_services/main_page_service.dart';
import 'package:tez_bazar/products_services/active_product_service.dart';
import 'package:tez_bazar/products_services/category_service.dart';
import 'package:tez_bazar/services/image_service.dart';
import 'package:tez_bazar/products_services/product_service.dart';
import 'package:tez_bazar/services/request_service.dart';
import 'package:tez_bazar/products_services/search_service.dart';
import 'package:tez_bazar/constants/text_constants.dart';
import 'package:tez_bazar/services/version_service.dart';

final requestServiceProvider = Provider<RequestService>((ref) {
  return RequestService(ref);
});

final mainServiceProvider = Provider<MainService>((ref) {
  return MainService(ref);
});

final categoriesProvider =
    StateNotifierProvider<CategoriesService, List<Category>>((ref) {
  return CategoriesService(ref);
});

final bannersProvider =
    StateNotifierProvider<BannersService, List<Banners>>((ref) {
  return BannersService(ref);
});

final activeProductProvider =
    StateNotifierProvider<ActiveProductService, List<ActiveProducts>>((ref) {
  return ActiveProductService(ref);
});

final productProvider =
    StateNotifierProvider<ProductService, List<Products>>((ref) {
  return ProductService(ref);
});

final searchProvider =
    StateNotifierProvider<ProductSearchService, List<SearchHistory>>((ref) {
  return ProductSearchService(ref);
});

final archiveProductsProvider =
    StateNotifierProvider<ArchiveProductsService, List<ArchiveProducts>>((ref) {
  return ArchiveProductsService(ref);
});

// Провайдер для состояния авторизации

enum BottomSelectedMenu { home, userProducts, account }

final routeProvider =
    StateProvider<BottomSelectedMenu>((ref) => BottomSelectedMenu.home);

enum GridPage { category, product, search }

final gridViewStateProvider =
    StateProvider<GridPage>((ref) => GridPage.category);

final appBarTitleProvider =
    StateProvider<String?>((ref) => TextConstants.homeTitle);

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

final googleSignInProvider = Provider<GoogleSignIn>(
  (ref) {
    return GoogleSignIn(
      scopes: ['email', 'profile'],
    );
  },
);

enum UserResponseState {
  loading,
  success,
  error,
  stateDefault,
}

final userServiceStateProvider =
    StateProvider<UserResponseState>((ref) => UserResponseState.stateDefault);

final loadingProvider = StateProvider<bool>((ref) {
  return false;
});

final listOfCategoriesProvider =
    StateProvider<Map<String, dynamic>>((ref) => {});

final loadTimer = StateProvider<int>((ref) => 1);

final imageUploadProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService();
});

final errorDialogProvider = StateProvider<bool>((ref) => false);

final errorDialogMessageProvider = StateProvider<String?>((ref) => null);

final refreshTimerProvider = Provider<int>((ref) => 1);

// Провайдер для состояния аккаунта
enum AccountState { account, profile }

final accountStateProvider =
    StateProvider<AccountState>((ref) => AccountState.account);

enum HomeState { home, category, search }

final homeStateProvider = StateProvider<HomeState>((ref) => HomeState.home);

final versionProvider = StateNotifierProvider<VersionService, String?>((ref) {
  return VersionService(ref);
});