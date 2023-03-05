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
        this.router.post('/users/login', this.userController.login);
        this.router.post('/users/isValidToken', this.userController.isLogged);
        this.router.post('/users/register', this.userController.register);
        this.router.post('/offers/register', this.offerController.register);
        this.router.post('/offers', this.offerController.getOffers);
        this.router.post('/offers/getByCity', this.offerController.getByCity);
        this.router.post('/offers/getById', this.offerController.getById);
        this.router.post('/favorites/addFavorite', this.favoriteController.addFavorite);
        this.router.post('/favorites/removeFavorite', this.favoriteController.removeFavorite);
        this.router.post('/favorites/getFavorites', this.favoriteController.getFavorites);
    }
}

export default MongoRoute;