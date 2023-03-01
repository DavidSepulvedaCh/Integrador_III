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
const userModel_1 = __importDefault(require("../model/userModel"));
const offerModel_1 = __importDefault(require("../model/offerModel"));
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const jwt = require('jsonwebtoken');
class MongoController {
    constructor() {
        this.userRegister = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { email, name, password } = req.body;
            let emailValidator = /^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$/;
            if (!email || !name || !password) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof email !== 'string' || typeof name !== 'string' || typeof password !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (email.length <= 1 || name.length <= 1 || password.length <= 1) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (!emailValidator.test(email)) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            const passwordEncrypt = yield bcryptjs_1.default.hash(password, 8);
            this.userModel.register(email, name, passwordEncrypt, (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                let token = this.generateToken(response.id);
                res.json({ token: token, messagge: response.success });
            });
        });
        this.login = (req, res) => {
            const { email, name, password } = req.body;
            if (!email || !name || !password) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof email !== 'string' || typeof name !== 'string' || typeof password !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (email.length <= 1 || name.length <= 1 || password.length <= 1) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.userModel.login(email, name, password, (response) => {
                if (response.error) {
                    return res.status(401).json({ error: response.error });
                }
                let token = this.generateToken(response.id);
                res.json({ token: token, messagge: response.success });
            });
        };
        this.isLogged = (req, res) => {
            const token = req.body.token;
            if (token) {
                let decodedToken;
                try {
                    decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
                }
                catch (_a) {
                    return res.json({ 'error': true, message: 'e104' });
                }
                if (!decodedToken.id) {
                    return res.json({ 'error': true, message: 'e104' });
                }
                return res.json({ 'error': false, message: 'Token valid' });
            }
        };
        this.userModel = new userModel_1.default();
        this.offerModel = new offerModel_1.default();
    }
    getOfferById(req, res) {
        throw new Error("Method not implemented.");
    }
    getOfferByCity(arg0, getOfferByCity) {
        throw new Error("Method not implemented.");
    }
    offerRegister(req, res) {
        const { address, name, description, photo, price, id_seller, city } = req.body;
        if (!address || !name || !description || !photo || !price || !id_seller || !city) {
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if (typeof address !== 'string' || typeof name !== 'string' || typeof description !== 'string' || typeof photo !== 'string' || typeof price !== 'number' || typeof id_seller !== 'string' || typeof city !== 'string') {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        if (address.length <= 1 || name.length <= 1 || description.length <= 1 || photo.length <= 1 || id_seller.length <= 1 || city.length <= 1 || price <= 1) {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
    }
    generateToken(email) {
        const token = jwt.sign({ email: email }, process.env.TOKEN_KEY, { expiresIn: "2h" });
        return token;
    }
}
exports.default = MongoController;
