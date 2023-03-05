"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const express_1 = require("express");
const userController_1 = __importDefault(require("../controller/userController"));
const offerController_1 = __importDefault(require("../controller/offerController"));
const favoriteController_1 = __importDefault(require("../controller/favoriteController"));
class MongoRoute {
    constructor() {
        this.config = () => {
            this.router.post('/users/login', this.userController.login);
            this.router.post('/users/isValidToken', this.userController.isLogged);
            this.router.post('/users/register', this.userController.register);
            this.router.post('/offers/register', this.offerController.register);
            this.router.post('/offers', this.offerController.getOffers);
            this.router.post('/offers/getByCity', this.offerController.getByCity);
            this.router.post('/offers/getById', this.offerController.getById);
            this.router.post('/favorites/addFavorite', this.favoriteController.addFavorite);
            this.router.post('/favorites/removeFavorite', this.favoriteController.removeFavorite);
            this.router.post('/favorites', this.favoriteController.getFavorites);
        };
        this.router = (0, express_1.Router)();
        this.userController = new userController_1.default();
        this.offerController = new offerController_1.default();
        this.favoriteController = new favoriteController_1.default();
        this.config();
    }
}
exports.default = MongoRoute;
