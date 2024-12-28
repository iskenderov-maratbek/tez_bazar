class TextConstants {
  static const String homeTitle = "Башкы бет";
  static const String profileTitle = "Профиль";
  static const String search = "Издөө";
  static const String productTitle = "Башкы бет";
  static String noWhatsapp = "WhatsApp номери жок";
  static String accountPageTitle = "Аккаунт";
  static String myOrdersTitle = "Менин жарнамаларым";
  static String singInTitle = "Регистрация / Вход";
  static String anyErrorText = 'Что-то пошло не так';
  static String authenticateTextRU =
      'Быстрая и простая авторизация через Google. Нажмите, чтобы войти мгновенно!';
  static String authenticateText =
      'Оной жана бат Google аркылуу катталуу учун томондогу баскычты басыныз!';
  static String authWithGoogleButton = 'Google аркылуу катталуу';
  static String usernameFieldLabel = 'Аты-жонунуз';
  static String phoneNumberFieldLabel = 'Телефон номуру';
  static String whatsappFieldLabel = 'WhatsApp номуру';
  static String locationFieldLabel = 'Дареги';
  static String textSaveButton = 'Сактоо';
  static String kgCounterCode = '+996';
  static String ruCounterCode = '+7';
  static String phoneWithWhatsapp = 'Ватсап номер да ушул номеримде';

  static String invalidNumberIncorrect = 'Номурунуз туура эмес терилген';
  static String invalidNumberEmpty = 'Номурунуз терилген жок';
  static String invalidWhatsappNumberEmpty = 'WhatsApp номер терилген жок';
  static String invalidWhatsappNumberIncorrect =
      'WhatsApp номер туура эмес терилген';
  static String invalidNameEmpty = 'Аты-жонунуз терилген жок';
  static String invalidNameIncorrect = 'Аты-жонунуз туура эмес терилген';
  static String userDataUpdated = 'Жаны киргизилген маалыматтар сакталды!';
  static String serverError = 'Сервердеги билдирилген бардык суранылмады';
  static String loadingStatus = 'Куто турунуз';
  static String description = 'Кошумча маалымат';
  static String price = 'Баасы';
  static String adName = 'Товардын аталышы';
  static String addNewAddTitle = 'Жаны товар кошуу';
  static String editAddTitle = 'Товарды башкаруу';
  static String deliveryText = 'Жеткирип беруу';

  static String emptyErrorText = 'Созсуз толтуруу зарыл';
  static String noAddress = 'Дареги жок';
  static String categories = 'Категориялар';
  static String activeAds = 'Активдуу товарлар';
  static String inactiveAds = 'Активдешпеген товарлар';

  static String priceTypePieces = 'Шт';
  static String priceTypeKgs = 'Кг';
  static String priceTypeLts = 'Литр';

  static List<String> itemsPriceType = [
    TextConstants.priceTypePieces,
    TextConstants.priceTypeLts,
    TextConstants.priceTypeKgs,
  ];

  static String statusTypeActive = 'Активдуу';
  static String statusTypeArchive = 'Архивделген';
  static String statusTypeModerate = 'Текшеруудо';
  static String statusTypeSold = 'Cатылган';
  static Map<String, String> itemsStatus = {
    TextConstants.statusModerate: TextConstants.statusTypeModerate,
    TextConstants.statusActive: TextConstants.statusTypeActive,
    TextConstants.statusSold: TextConstants.statusTypeSold,
    TextConstants.statusArchive: TextConstants.statusTypeArchive,
  };
  static String statusModerate = 'moderate';
  static String statusActive = 'active';
  static String statusSold = 'sold';
  static String statusArchive = 'archive';
  static String notEmpty = 'Толтуруу зарыл';
  static String notOnlyDigits = ' Жалан сандардан болбошу керек';
  static String minLegth = '3 символдон аз болбошу керек';
  static String noResults = 'Сиздин талабыныз боюнча маалымат табылган жок';
  static String confirmDeleteAdText = 'Товарды очурууну каалайсызбы?';
  static String confirmActiveAdText = 'Товарды жарыялоону каалайсызбы?';
  static String confirmArchiveAdText = 'Товарды архивке откорууну каалайсызбы?';
  static String toDeleteText = 'Жокко чыгаруу';
  static String toArchiveText = 'Архивке жонотуу';
  static String toActiveText = 'Жарыялоо';
  static String unknownError = 'Что-то пошло не так';

  static var editAdREQ;
}
