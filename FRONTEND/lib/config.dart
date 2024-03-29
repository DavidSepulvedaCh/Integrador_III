class Config {
  static const String apiURL = '207.248.81.71:3000';
  static const String loginAPI = '/api/users/login';
  static const String registerAPI = '/api/users/person/register';
  static const String isValidTokenAPI = '/api/users/isValidToken';
  static const String getRestaurantDetails =
      '/api/users/restaurant/getInformationByIdUser';
  static const String getRestaurantById = '/api/users/restaurant/getById';
  static const String getInformationOfAllRestaurants =
      '/api/users/restaurant/getInformationOfAllRestaurants';
  static const String getOffers = '/api/offers';
  static const String getOfferById = '/api/offers/getById';
  static const String getOfferByPriceRange = '/api/offers/getByPriceRange';
  static const String getOfferByCity = '/api/offers/getByCity';
  static const String getOfferByCityAndPriceRange =
      '/api/offers/getByCityAndPriceRange';
  static const String getOffersByIdUser = '/api/offers/getByIdUser';
  static const String removeOffer = '/api/offers/remove';
  static const String createOffer = 'api/offers/register';
  static const String updateFavorite = '/api/favorites/updateFavorites';
  static const String getFavorites = '/api/favorites';
  static const String addFavorite = '/api/favorites/addFavorite';
  static const String removeFavorite = '/api/favorites/removeFavorite';
  static const String getMaxPriceAllOffers = 'api/offers/getMaxPriceAllOffers';
  static const String registerRestaurant = '/api/users/restaurant/register';
  static const String updateRestaurantName = '/api/users/restaurant/updateName';
  static const String updatePhoto = '/api/users/updatePhoto';
  static const String updateRestaurantDescription =
      '/api/users/restaurant/updateDescription';
  static const String registerBiometric = '/api/users/register/biometric';
  static const String removeBiometric = '/api/users/remove/biometric';
  static const String loginBiometric = '/api/users/login/biometric';
  static const String addInformationUserNotification =
      '/api/users/firebase/addInformation';
  static const String removeInformationUserNotification =
      '/api/users/firebase/removeInformation';
}
