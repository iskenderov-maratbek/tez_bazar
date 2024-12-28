import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tez_bazar/models/ads.dart';

import 'package:tez_bazar/models/categories.dart';
import 'package:tez_bazar/models/products.dart';
import 'package:tez_bazar/models/search_history.dart';
import 'package:tez_bazar/services/ads_service.dart';
import 'package:tez_bazar/services/category_service.dart';
import 'package:tez_bazar/services/image_service.dart';
import 'package:tez_bazar/services/product_service.dart';
import 'package:tez_bazar/services/search_service.dart';
import 'package:tez_bazar/texts/text_constants.dart';

// Модель данных

// Провайдер для получения данных с пагинацией
final categoryProvider =
    StateNotifierProvider<CategoryService, List<Category>>((ref) {
  return CategoryService(ref);
});

final adsProvider = StateNotifierProvider<AdsService, List<Ads>>((ref) {
  return AdsService();
});

final productProvider =
    StateNotifierProvider<ProductService, List<Products>>((ref) {
  return ProductService(ref);
});

final searchProvider =
    StateNotifierProvider<ProductSearchService, List<SearchHistory>>((ref) {
  return ProductSearchService(ref);
});

// Провайдер для состояния авторизации

enum BottomSelectedMenu { home, ads, account }

final bottomSelectedProvider =
    StateProvider<BottomSelectedMenu>((ref) => BottomSelectedMenu.home);

enum GridPage { category, product, search }

final gridViewStateProvider =
    StateProvider<GridPage>((ref) => GridPage.category);

final appBarTitleProvider =
    StateProvider<String?>((ref) => TextConstants.homeTitle);

final isAuthenticatedProvider = StateProvider<bool>((ref) => false);

enum AuthViewContent {
  accountPage,
  signInPage,
  error,
  profile,
}

final authViewProvider =
    StateProvider<AuthViewContent>((ref) => AuthViewContent.signInPage);

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

final categoriesProvider = StateProvider<Map<String, dynamic>>((ref) => {});

final loadTimer = StateProvider<int>((ref) => 1);

final imageUploadProvider = Provider<ImageUploadService>((ref) {
  return ImageUploadService();
});

final errorDialogProvider = StateProvider<bool>((ref) => false);

final errorDialogMessageProvider = StateProvider<String?>((ref) => null);

final refreshTimerProvider = Provider<int>((ref) => 1);