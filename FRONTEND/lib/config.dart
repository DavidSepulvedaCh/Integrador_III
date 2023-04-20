class Config{
<<<<<<< Updated upstream
  static const String apiURL = '10.153.82.14:1802';
=======
  static const String apiURL = '10.153.50.45:1802';
>>>>>>> Stashed changes
  static const String loginAPI = '/api/users/login';
  static const String registerAPI = '/api/users/person/register';
  static const String isValidTokenAPI = '/api/users/isValidToken';
  static const String getRestaurantDetails= '/api/users/restaurant/getInformationByIdUser';
  static const String getOffers = '/api/offers';
  static const String getOfferById = '/api/offers/getById';
  static const String getOfferByPriceRange = '/api/offers/getByPriceRange';
  static const String updateFavorite = '/api/favorites/updateFavorites';
  static const String getFavorites = '/api/favorites';
  static const String getMaxPriceAllOffers = 'api/offers/getMaxPriceAllOffers';
}