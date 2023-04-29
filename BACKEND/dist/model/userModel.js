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
const userSchema_1 = __importDefault(require("../mongoDB/schemas/userSchema"));
const biometricLoginUserData_1 = __importDefault(require("../mongoDB/schemas/biometricLoginUserData"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const mongodb_1 = require("mongodb");
class UserModel {
    constructor() {
        this.register = (email, name, password, role, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let userDetails = new userSchema_1.default({
                email: email,
                name: name,
                password: password,
                photo: 'https://bit.ly/3Lstjcq',
                role: role
            });
            const userExists = yield this.MongoDBC.UserSchema.findOne({
                email: { $eq: email }
            });
            if (userExists != null) {
                return fn({
                    error: 'Email already exists'
                });
            }
            const newUser = yield userDetails.save();
            if (newUser._id) {
                return fn({
                    success: 'Register success',
                    id: newUser._id
                });
            }
            return fn({
                error: 'Register error'
            });
        });
        this.login = (email, password, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const userExists = yield this.MongoDBC.UserSchema.findOne({
                email: { $eq: email }
            });
            if (userExists == null) {
                return fn({
                    error: 'Email or password incorrect'
                });
            }
            let compare = bcryptjs_1.default.compareSync(password, userExists.password);
            if (!compare) {
                return fn({
                    error: 'Email or password incorrect'
                });
            }
            return fn({
                success: 'Login success',
                id: userExists._id,
                email: email,
                name: userExists.name,
                photo: userExists.photo,
                role: userExists.role
            });
        });
        this.getUserById = (id) => __awaiter(this, void 0, void 0, function* () {
            try {
                const userExists = yield this.MongoDBC.UserSchema.findById(id);
                return true;
            }
            catch (error) {
                return false;
            }
        });
        this.registerBiometric = (email, password, token, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const userExists = yield this.MongoDBC.UserSchema.findOne({
                email: { $eq: email }
            });
            if (userExists == null) {
                return fn({
                    error: 'Email or password incorrect'
                });
            }
            let compare = bcryptjs_1.default.compareSync(password, userExists.password);
            if (!compare) {
                return fn({
                    error: 'Email or password incorrect'
                });
            }
            let biometricLoginUserDataDetails = new biometricLoginUserData_1.default({
                email: email,
                password: userExists.password,
                token: token
            });
            try {
                const newUser = yield biometricLoginUserDataDetails.save();
                if (newUser._id) {
                    return fn({
                        success: 'Register success'
                    });
                }
            }
            catch (error) {
                return fn({
                    error: error,
                    message: 'Token already exists'
                });
            }
            return fn({
                error: 'Register error'
            });
        });
        this.biometricLogin = (token, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const userExistsToken = yield this.MongoDBC.BiometricLoginUserDataSchema.findOne({
                token: { $eq: token }
            });
            const userExists = yield this.MongoDBC.UserSchema.findOne({
                email: { $eq: userExistsToken.email }
            });
            if (userExists == null) {
                return fn({
                    error: 'Email or password incorrect'
                });
            }
            return fn({
                success: 'Login success',
                id: userExists._id,
                email: userExists.email,
                name: userExists.name,
                role: userExists.role
            });
        });
        this.removeBiometricLogin = (token, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const userExists = yield this.MongoDBC.BiometricLoginUserDataSchema.findOne({
                token: { $eq: token }
            });
            if (userExists) {
                const remove = yield this.MongoDBC.BiometricLoginUserDataSchema.deleteOne({
                    token: { $eq: token }
                });
                fn(remove);
            }
        });
        this.restaurantRegister = (restaurantDetails, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            try {
                const userExists = yield this.MongoDBC.UserSchema.findById(restaurantDetails.idUser);
                if (userExists == null) {
                    return fn({
                        error: 'User does not exist'
                    });
                }
                const newRestaurant = yield restaurantDetails.save();
                if (newRestaurant._id) {
                    return fn({
                        success: 'Register success'
                    });
                }
                return fn({
                    error: 'Register error'
                });
            }
            catch (error) {
                console.log(error);
            }
        });
        this.getRestaurantInformationByIdUser = (idUser, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            const restaurantExists = yield this.MongoDBC.RestaurantSchema.findOne({
                idUser: { $eq: idUser }
            });
            if (restaurantExists == null) {
                return fn({
                    error: 'User does not exist'
                });
            }
            return fn({
                success: 'Login success',
                photo: restaurantExists.photo,
                description: restaurantExists.description,
                latitude: restaurantExists.latitude,
                longitude: restaurantExists.longitude,
                address: restaurantExists.address,
                city: restaurantExists.city
            });
        });
        this.getInformationAllRestaurants = (fn) => __awaiter(this, void 0, void 0, function* () {
            try {
                this.MongoDBC.connection();
                const restaurants = yield this.MongoDBC.RestaurantSchema.aggregate([
                    {
                        $lookup: {
                            from: "users",
                            localField: "idUser",
                            foreignField: "_id",
                            as: "user"
                        }
                    },
                    {
                        $unwind: "$user"
                    }
                ]);
                console.log(restaurants);
                return fn({ success: "success" });
            }
            catch (error) {
                console.error(error);
                return fn({ error: "error" });
            }
        });
        this.updateRestaurantName = (idUser, name, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            try {
                const result = yield this.MongoDBC.UserSchema.updateOne({ _id: new mongodb_1.ObjectId(idUser) }, { $set: { name: name } });
                if (result.modifiedCount == 0) {
                    return fn({ error: 'User does not exist' });
                }
                else {
                    return fn({ success: 'Update successful' });
                }
            }
            catch (error) {
                return fn({ error: 'User does not exist' });
            }
        });
        this.updatePhoto = (id, photo, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            try {
                const result = yield this.MongoDBC.UserSchema.updateOne({ _id: new mongodb_1.ObjectId(id) }, { $set: { photo: photo } });
                if (result.modifiedCount == 0) {
                    return fn({ error: 'User does not exist' });
                }
                else {
                    return fn({ success: 'Update successful' });
                }
            }
            catch (error) {
                return fn({ error: 'User does not exist' });
            }
        });
        this.updateRestaurantDescription = (idUser, description, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            try {
                const result = yield this.MongoDBC.RestaurantSchema.updateOne({ idUser: idUser }, { $set: { description: description } });
                if (result.modifiedCount == 0) {
                    return fn({ error: 'User does not exist' });
                }
                else {
                    return fn({ success: 'Update successful' });
                }
            }
            catch (error) {
                return fn({ error: 'User does not exist' });
            }
        });
        this.MongoDBC = new mongoDBC_1.default();
    }
}
exports.default = UserModel;
