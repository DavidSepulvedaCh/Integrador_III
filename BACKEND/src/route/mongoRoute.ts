import { Router } from "express";
import UserController from "../controller/userController";
import OfferController from "../controller/offerController";

class MongoRoute{

    public router: Router;
    private userController: UserController;
    private offerController: OfferController;

    constructor(){
        this.router = Router();
        this.userController = new UserController();
        this.offerController = new OfferController();
        this.config();
    }

    private config = () => {
        this.router.post('/users/login', this.userController.login);
        this.router.post('/users/isValidToken', this.userController.isLogged)
        this.router.post('/users/register', this.userController.register);
        this.router.post('/offers/register', this.offerController.register);
        this.router.post('/offers/getByCity', this.offerController.getByCity);
        this.router.post('/offers/getById', this.offerController.getById);
    }
}

export default MongoRoute;