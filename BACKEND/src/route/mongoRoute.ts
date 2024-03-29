import { Router } from "express";
import UserController from "../controller/userController";
import OfferController from "../controller/offerController";
import FavoriteController from "../controller/favoriteController";

class MongoRoute{

    public router: Router;
    private userController: UserController;
    private offerController: OfferController;
    private favoriteController: FavoriteController;

    constructor(){
        this.router = Router();
        this.userController = new UserController();
        this.offerController = new OfferController();
        this.favoriteController = new FavoriteController();
        this.config();
    }

    private config = () => {
        this.router.post('/users/register/biometric', this.userController.registerBiometric);
        this.router.post('/users/login/biometric', this.userController.biometricLogin);
        this.router.post('/users/remove/biometric', this.userController.removeBiometric);
        this.router.post('/users/login', this.userController.login);
        this.router.post('/users/isValidToken', this.userController.isLogged);
        this.router.post('/users/person/register', this.userController.personRegister);
        this.router.post('/users/restaurant/register', this.userController.restaurantRegister);
        this.router.post('/users/restaurant/getInformationByIdUser', this.userController.getRestaurantInformationByIdUser);
        this.router.post('/users/restaurant/updateName', this.userController.updateRestaurantName);
        this.router.post('/users/updatePhoto', this.userController.updatePhoto);
        this.router.post('/users/restaurant/updateDescription', this.userController.updateRestaurantDescription);
        this.router.post('/users/restaurant/getById', this.userController.getRestaurantById);
        this.router.post('/users/restaurant/getInformationOfAllRestaurants', this.userController.getInformationAllRestaurants);
        this.router.post('/users/firebase/addInformation', this.userController.addInformationFirebase);
        this.router.post('/users/firebase/removeInformation', this.userController.removeInformationFirebase);
        this.router.post('/offers', this.offerController.getOffers);
        this.router.post('/offers/register', this.offerController.register);
        this.router.post('/offers/getByCity', this.offerController.getByCity);
        this.router.post('/offers/getByCityAndPriceRange', this.offerController.getByCityAndPriceRange);
        this.router.post('/offers/getById', this.offerController.getById);
        this.router.post('/offers/getByListIds', this.offerController.getByListIds);
        this.router.post('/offers/getMaxPriceAllOffers', this.offerController.getMaxPriceAllOffers);
        this.router.post('/offers/getByPriceRange', this.offerController.getByPriceRange);
        this.router.post('/offers/getByIdUser', this.offerController.getByIdUser);
        this.router.post('/offers/remove', this.offerController.remove);
        this.router.post('/favorites', this.favoriteController.getFavorites);
        this.router.post('/favorites/updateFavorites', this.favoriteController.updateFavorites);
        this.router.post('/favorites/addFavorite', this.favoriteController.addFavorite);
        this.router.post('/favorites/removeFavorite', this.favoriteController.removeFavorite);
    }
}

export default MongoRoute;