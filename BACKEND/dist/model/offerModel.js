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
const offerSchema_1 = __importDefault(require("../mongoDB/schemas/offerSchema"));
class OfferModel {
    constructor() {
        this.getById = (id, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            try {
                let offer = yield this.MongoDBC.OfferSchema.findById(id);
                return fn({
                    offer: offer
                });
            }
            catch (error) {
                return fn({
                    error: 'Invalid id'
                });
            }
        });
        this.getByIds = (idsList, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let offer = yield this.MongoDBC.OfferSchema.find({
                _id: { $in: idsList }
            });
            return fn({
                offers: offer
            });
        });
        this.getByCity = (city, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const products = yield this.MongoDBC.OfferSchema.find({
                city: { $eq: city }
            });
            fn(products);
        });
        this.register = (address, name, description, photo, price, id_seller, city, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let offerDetails = new offerSchema_1.default({
                address: address, name: name, description: description, photo: photo, price: price, id_seller: id_seller, city: city
            });
            try {
                yield this.MongoDBC.UserSchema.findById(id_seller);
            }
            catch (error) {
                return fn({
                    error: 'Invalid id'
                });
            }
            const newOffer = yield offerDetails.save();
            if (newOffer._id) {
                return fn({
                    success: 'Register success',
                    id: newOffer._id
                });
            }
            return fn({
                error: 'Register error'
            });
        });
        this.offerExists = (id) => __awaiter(this, void 0, void 0, function* () {
            try {
                const offerExists = yield this.MongoDBC.OfferSchema.findById(id);
                return true;
            }
            catch (error) {
                return false;
            }
        });
        this.MongoDBC = new mongoDBC_1.default();
    }
}
exports.default = OfferModel;
