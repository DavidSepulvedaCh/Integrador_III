"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = __importDefault(require("mongoose"));
const userSchema_1 = __importDefault(require("./schemas/userSchema"));
const offerSchema_1 = __importDefault(require("./schemas/offerSchema"));
const dotenv_1 = __importDefault(require("dotenv"));
class MongoDBC {
    constructor() {
        dotenv_1.default.config();
        this.uri = `mongodb+srv://${process.env.USER}:${process.env.PASS}@cluster0.a87koto.mongodb.net/${process.env.DBNAME}?retryWrites=true&w=majority`;
        this.UserSchema = userSchema_1.default;
        this.OfferSchema = offerSchema_1.default;
    }
    connection() {
        mongoose_1.default.connect(this.uri)
            .then(() => { console.log('DB: Mongo connection'); })
            .catch((err) => { console.log('Error connecting MongoDB: ', err); });
    }
}
exports.default = MongoDBC;
