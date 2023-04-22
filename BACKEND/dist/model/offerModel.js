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
var __asyncValues = (this && this.__asyncValues) || function (o) {
    if (!Symbol.asyncIterator) throw new TypeError("Symbol.asyncIterator is not defined.");
    var m = o[Symbol.asyncIterator], i;
    return m ? m.call(o) : (o = typeof __values === "function" ? __values(o) : o[Symbol.iterator](), i = {}, verb("next"), verb("throw"), verb("return"), i[Symbol.asyncIterator] = function () { return this; }, i);
    function verb(n) { i[n] = o[n] && function (v) { return new Promise(function (resolve, reject) { v = o[n](v), settle(resolve, reject, v.done, v.value); }); }; }
    function settle(resolve, reject, d, v) { Promise.resolve(v).then(function(v) { resolve({ value: v, done: d }); }, reject); }
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
        this.getOffers = (fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const products = yield this.MongoDBC.OfferSchema.find({ active: true });
            fn(products);
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
        this.register = (address, latitude, longitude, name, description, photo, price, idSeller, city, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let offerDetails = new offerSchema_1.default({
                address: address, latitude: latitude, longitude: longitude, name: name, description: description, photo: photo, price: price, idSeller: idSeller, restaurantName: "", city: city
            });
            try {
                const user = yield this.MongoDBC.UserSchema.findById(idSeller);
                offerDetails.restaurantName = user.name;
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
        this.getMaxPriceAllOffers = (fn) => __awaiter(this, void 0, void 0, function* () {
            var _a, e_1, _b, _c;
            this.MongoDBC.connection();
            const cursor = yield this.MongoDBC.OfferSchema.aggregate([
                { $group: { _id: null, maxPrice: { $max: "$price" } } }
            ]);
            let maxPrice = -Infinity;
            try {
                for (var _d = true, cursor_1 = __asyncValues(cursor), cursor_1_1; cursor_1_1 = yield cursor_1.next(), _a = cursor_1_1.done, !_a;) {
                    _c = cursor_1_1.value;
                    _d = false;
                    try {
                        const result = _c;
                        maxPrice = result.maxPrice;
                    }
                    finally {
                        _d = true;
                    }
                }
            }
            catch (e_1_1) { e_1 = { error: e_1_1 }; }
            finally {
                try {
                    if (!_d && !_a && (_b = cursor_1.return)) yield _b.call(cursor_1);
                }
                finally { if (e_1) throw e_1.error; }
            }
            return fn({
                maxPrice: maxPrice
            });
        });
        this.getByPriceRange = (minPrice, maxPrice, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let offers = yield this.MongoDBC.OfferSchema.find({ price: { $gte: minPrice, $lte: maxPrice }, active: true });
            fn(offers);
        });
        this.getByIdUser = (idUser, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const offer = yield this.MongoDBC.OfferSchema.find({
                idSeller: { $eq: idUser },
                active: true
            });
            fn(offer);
        });
        this.remove = (id, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let offer = null;
            try {
                offer = yield this.MongoDBC.OfferSchema.findById(id);
            }
            catch (error) {
                return fn({
                    error: 'Invalid id'
                });
            }
            if (offer.active != true) {
                return fn({
                    error: "Offer isn't active"
                });
            }
            offer.active = false;
            const result = yield offer.save();
            if (result.active == false) {
                return fn({
                    success: 'Successful remove'
                });
            }
            else {
                return fn({
                    error: "Delete failed"
                });
            }
        });
        this.MongoDBC = new mongoDBC_1.default();
    }
}
exports.default = OfferModel;
