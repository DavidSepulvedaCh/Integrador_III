"use strict";
var __awaiter = (this && this.__awaiter) || function (thisArg, _arguments, P, generator) {
    function adopt(value) { return value instanceof P ? value : new P(function (resolve) { resolve(value); }); }
    return new (P || (P = Promise))(function (resolve, reject) {
        function fulfilled(value) { try { step(generator.next(value)); } catch (e) { reject(e); } }
        function rejected(value) { try { step(generator["throw"](value)); } catch (e) { reject(e); } }
        function step(result) { result.done ? resolve(result.value) : adopt(result.value).then(fulfilled, rejected); }
        step((generator = generator.apply(thisArg, _arguments || [])).next());
    });
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const favoritesModel_1 = __importDefault(require("../model/favoritesModel"));
const offerModel_1 = __importDefault(require("../model/offerModel"));
const userModel_1 = __importDefault(require("../model/userModel"));
class FavoriteController {
    constructor() {
        this.updateFavorites = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const ids = req.body.ids;
            const { idUser } = req.body;
            if (!ids || !idUser) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            const currentFavorites = yield new Promise((resolve, reject) => {
                this.favoritesModel.getFavorites(idUser, (favorites) => {
                    resolve(favorites);
                });
            });
            const currentIds = currentFavorites.map((favorite) => favorite.idRestaurant);
            /* ======================== For to add the ids ===================== */
            if (ids.length > 0) {
                for (let i = 0; i < ids.length; i++) {
                    const id = ids[i];
                    if (currentIds.includes(id)) {
                        continue;
                    }
                    else {
                        var restaurantExists = yield this.userModel.restaurantExists(id);
                        if (!restaurantExists) {
                            return res.status(400).send({
                                error: 'Invalid data'
                            });
                        }
                        this.favoritesModel.addFavorite(idUser, id, (response) => {
                            if (response.error) {
                                return res.status(400).send({
                                    error: response.error
                                });
                            }
                        });
                    }
                }
            }
            /* ======================== For to remove the ids ===================== */
            for (let i = 0; i < currentIds.length; i++) {
                const id = currentIds[i];
                if (ids.includes(id)) {
                    continue;
                }
                else {
                    this.favoritesModel.removeFavorite(idUser, id, (response) => {
                        if (response.deletedCount != 1) {
                            return res.status(400).send({
                                error: response.error
                            });
                        }
                    });
                }
            }
            return res.status(200).json({ 'success': 'Favorites update successful' });
        });
        this.addFavorite = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { idUser, idRestaurant } = req.body;
            if (!idUser || !idRestaurant) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof idUser !== 'string' || typeof idRestaurant !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var favoriteExists = yield this.favoritesModel.favoriteExists(idUser, idRestaurant);
            if (favoriteExists) {
                return res.status(410).send({
                    error: 'Favorite already exists'
                });
            }
            var userExists = yield this.userModel.getUserById(idUser);
            if (!userExists) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var restaurantExists = yield this.userModel.restaurantExists(idRestaurant);
            if (!restaurantExists) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.favoritesModel.addFavorite(idUser, idRestaurant, (response) => {
                if (response.error) {
                    return res.status(400).send({
                        error: response.error
                    });
                }
                return res.status(200).json({ id: response.id });
            });
        });
        this.removeFavorite = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { idUser, idRestaurant } = req.body;
            if (!idUser || !idRestaurant) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof idUser !== 'string' || typeof idRestaurant !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var favoriteExists = yield this.favoritesModel.favoriteExists(idUser, idRestaurant);
            if (!favoriteExists) {
                return res.status(400).send({
                    error: 'Favorite no exists'
                });
            }
            this.favoritesModel.removeFavorite(idUser, idRestaurant, (response) => {
                if (response.deletedCount != 1) {
                    return res.status(400).send({
                        error: response.error
                    });
                }
                return res.status(200).json({ response: response });
            });
        });
        this.getFavorites = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { idUser } = req.body;
            if (!idUser) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof idUser !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var ids_restaurants;
            yield this.favoritesModel.getFavorites(idUser, (response) => {
                ids_restaurants = response.map((element) => element.idRestaurant);
            });
            if (ids_restaurants.length == 0) {
                return res.status(200).json({ restaurants: ids_restaurants });
            }
            this.userModel.getRestaurantsInformationByIds(ids_restaurants, (response) => {
                return res.status(200).send(response);
            });
        });
        this.favoritesModel = new favoritesModel_1.default();
        this.userModel = new userModel_1.default();
        this.offerModel = new offerModel_1.default();
    }
}
exports.default = FavoriteController;
