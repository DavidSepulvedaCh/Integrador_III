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
const mongoDBC_1 = __importDefault(require("../mongoDB/mongoDBC"));
const favoriteSchema_1 = __importDefault(require("../mongoDB/schemas/favoriteSchema"));
class FavoritesModel {
    constructor() {
        this.addFavorite = (idUser, idRestaurant, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let favoriteDetails = new favoriteSchema_1.default({
                idUser: idUser,
                idRestaurant: idRestaurant
            });
            const newFavorite = yield favoriteDetails.save();
            if (newFavorite._id) {
                return fn({
                    success: 'Register success',
                    id: newFavorite._id
                });
            }
            return fn({
                error: 'Register error'
            });
        });
        this.removeFavorite = (idUser, idRestaurant, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const deleteFavorite = yield this.MongoDBC.FavoriteSchema.deleteOne({
                idUser: idUser,
                idRestaurant: idRestaurant
            });
            fn(deleteFavorite);
        });
        this.getFavorites = (idUser, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const favorites = yield this.MongoDBC.FavoriteSchema.find({
                idUser: { $eq: idUser }
            });
            fn(favorites);
        });
        this.favoriteExists = (idUser, idRestaurant) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const favorite = yield this.MongoDBC.FavoriteSchema.find({
                idRestaurant: { $eq: idRestaurant }
            });
            if (favorite.length > 0) {
                return true;
            }
            return false;
        });
        this.MongoDBC = new mongoDBC_1.default();
    }
}
exports.default = FavoritesModel;
