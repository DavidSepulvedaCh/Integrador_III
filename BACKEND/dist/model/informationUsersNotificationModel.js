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
const informationUsersNotification_1 = __importDefault(require("../mongoDB/schemas/informationUsersNotification"));
const favoritesModel_1 = __importDefault(require("../model/favoritesModel"));
const firebaseConnect_1 = __importDefault(require("../firebase/firebaseConnect"));
class InformationUsersNotificationModel {
    constructor() {
        this.add = (idUser, token, fn) => __awaiter(this, void 0, void 0, function* () {
            try {
                this.MongoDBC.connection();
                const existingUser = yield this.MongoDBC.InformationUsersNotification.findOne({ token: { $eq: token } });
                if (existingUser) {
                    // If a document already exists for the provided token, update idUser
                    existingUser.idUser = idUser;
                    const updateUser = yield existingUser.save();
                    if (updateUser) {
                        return fn({
                            success: 'Update success',
                            id: existingUser._id
                        });
                    }
                    else {
                        return fn({
                            error: 'Update error'
                        });
                    }
                }
                else {
                    // If there is no existing document, create a new one
                    let userNotificationDetails = new informationUsersNotification_1.default({
                        idUser: idUser,
                        token: token
                    });
                    const newUser = yield userNotificationDetails.save();
                    if (newUser._id) {
                        return fn({
                            success: 'Register success',
                            id: newUser._id
                        });
                    }
                    else {
                        return fn({
                            error: 'Register error'
                        });
                    }
                }
            }
            catch (error) {
                console.error(error);
                return fn({
                    error: 'Register error'
                });
            }
        });
        this.remove = (token, fn) => __awaiter(this, void 0, void 0, function* () {
            try {
                this.MongoDBC.connection();
                const deletedUser = yield this.MongoDBC.InformationUsersNotification.findOneAndDelete({ token: { $eq: token } });
                if (deletedUser) {
                    return fn({
                        success: 'Delete success'
                    });
                }
                else {
                    return fn({
                        error: "Doesn't exists a register with that token"
                    });
                }
            }
            catch (error) {
                return fn({
                    error: 'Delete error'
                });
            }
        });
        this.sendNotification = (idRestaurant, restaurantName, offerName) => __awaiter(this, void 0, void 0, function* () {
            try {
                const userIds = yield this.favoritesModel.getIdsUsersHaveRestaurantFavorite(idRestaurant);
                this.MongoDBC.connection();
                const tokens = yield this.MongoDBC.InformationUsersNotification.find({ idUser: { $in: userIds.idUser } });
                const tokensArray = userIds.map((register) => register.token);
                if (tokensArray.length == 0) {
                    return;
                }
                const message = {
                    notification: {
                        title: "¡Nueva oferta disponible!",
                        body: `El restaurante ${restaurantName} ha publicado una nueva oferta: ${offerName}`,
                    },
                    tokens: tokens,
                };
                this.firebaseConnect.initializeApp();
                yield this.firebaseConnect.admin.messaging().sendMulticast(message);
                return;
            }
            catch (error) {
                console.log("Error sendNotification: " + error);
            }
        });
        this.MongoDBC = new mongoDBC_1.default();
        this.favoritesModel = new favoritesModel_1.default();
        this.firebaseConnect = new firebaseConnect_1.default();
    }
}
exports.default = InformationUsersNotificationModel;
