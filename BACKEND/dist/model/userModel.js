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
const bcryptjs_1 = __importDefault(require("bcryptjs"));
class UserModel {
    constructor() {
        this.register = (email, name, password, fn) => __awaiter(this, void 0, void 0, function* () {
            this.MongoDBC.connection();
            let userDetails = new userSchema_1.default({
                email: email,
                name: name,
                password: password
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
                name: userExists.name
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
        this.MongoDBC = new mongoDBC_1.default();
    }
}
exports.default = UserModel;
