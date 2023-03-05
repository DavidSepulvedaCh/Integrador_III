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
        this.addFavorite = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { id_user, id_offer } = req.body;
            if (!id_user || !id_offer) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof id_user !== 'string' || typeof id_offer !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var favoriteExists = yield this.favoritesModel.favoriteExists(id_user, id_offer);
            if (favoriteExists) {
                return res.status(400).send({
                    error: 'Favorite already exists'
                });
            }
            var userExists = yield this.userModel.getUserById(id_user);
            if (!userExists) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var offerExists = yield this.offerModel.offerExists(id_offer);
            if (!offerExists) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.favoritesModel.addFavorite(id_user, id_offer, (response) => {
                if (response.error) {
                    return res.status(400).send({
                        error: response.error
                    });
                }
                return res.status(200).json({ id: response.id });
            });
        });
        this.removeFavorite = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { id_user, id_offer } = req.body;
            if (!id_user || !id_offer) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof id_user !== 'string' || typeof id_offer !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var favoriteExists = yield this.favoritesModel.favoriteExists(id_user, id_offer);
            if (!favoriteExists) {
                return res.status(400).send({
                    error: 'Favorite no exists'
                });
            }
            this.favoritesModel.removeFavorite(id_user, id_offer, (response) => {
                if (response.deletedCount != 1) {
                    return res.status(400).send({
                        error: response.error
                    });
                }
                return res.status(200).json({ response: response });
            });
        });
        this.getFavorites = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { id_user } = req.body;
            if (!id_user) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof id_user !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            var ids_offers;
            yield this.favoritesModel.getFavorites(id_user, (response) => {
                ids_offers = response.map((element) => element.id_offer);
            });
            if (ids_offers.length == 0) {
                return res.status(200).json({ offers: ids_offers });
            }
            this.offerModel.getByIds(ids_offers, (response) => {
                return res.status(200).send(response);
            });
        });
        this.favoritesModel = new favoritesModel_1.default();
        this.userModel = new userModel_1.default();
        this.offerModel = new offerModel_1.default();
    }
}
exports.default = FavoriteController;
