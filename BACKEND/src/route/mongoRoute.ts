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
        this.router.post('/offers/register', this.offerController.register);
        this.router.post('/offers', this.offerController.getOffers);
        this.router.post('/offers/getByCity', this.offerController.getByCity);
        this.router.post('/offers/getById', this.offerController.getById);
        this.router.post('/offers/getByListIds', this.offerController.getByListIds);
        this.router.post('/favorites', this.favoriteController.getFavorites);
        this.router.post('/favorites/updateFavorites', this.favoriteController.updateFavorites);
        this.router.post('/favorites/addFavorite', this.favoriteController.addFavorite);
        this.router.post('/favorites/removeFavorite', this.favoriteController.removeFavorite);
    }
}

export default MongoRoute;