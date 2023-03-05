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
        this.addFavorite = (id_user, id_offer, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let favoriteDetails = new favoriteSchema_1.default({
                id_user: id_user,
                id_offer: id_offer
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
        this.removeFavorite = (id_user, id_offer, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const deleteFavorite = yield this.MongoDBC.FavoriteSchema.deleteOne({
                id_user: id_user,
                id_offer: id_offer
            });
            fn(deleteFavorite);
        });
        this.getFavorites = (id_user, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const favorites = yield this.MongoDBC.FavoriteSchema.find({
                id_user: { $eq: id_user }
            });
            fn(favorites);
        });
        this.favoriteExists = (id_user, id_offer) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const favorite = yield this.MongoDBC.FavoriteSchema.find({
                id_offer: { $eq: id_offer }
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
