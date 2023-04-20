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
const bcryptjs_1 = __importDefault(require("bcryptjs"));
const restaurantSchema_1 = __importDefault(require("../mongoDB/schemas/restaurantSchema"));
const jwt = require('jsonwebtoken');
class UserController {
    constructor() {
        this.personRegister = (req, res) => __awaiter(this, void 0, void 0, function* () {
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
            const passwordEncrypt = yield bcryptjs_1.default.hash(password, 8);
            this.userModel.register(email, name, passwordEncrypt, "person", (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                let token = this.generateToken(response.id, email, name, 'person');
                res.json({ id: response.id, name: name, email: email, role: 'person', token: token, messagge: response.success });
            });
        });
        this.restaurantRegister = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { email, name, password, latitude, longitude, address } = req.body;
            if (!email || !name || !password || !latitude || !longitude) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof email !== 'string' || typeof name !== 'string' || typeof password !== 'string' || typeof latitude !== 'string' || typeof longitude !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (email.length <= 1 || name.length <= 1 || password.length <= 1 || latitude.length <= 1 || longitude.length <= 1) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            const passwordEncrypt = yield bcryptjs_1.default.hash(password, 8);
            let restaurantDetails = new restaurantSchema_1.default({
                idUser: '',
                latitude: latitude,
                longitude: longitude,
                address: address
            });
            let token;
            yield this.userModel.register(email, name, passwordEncrypt, "restaurant", (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                token = this.generateToken(response.id, email, name, 'restaurant');
                restaurantDetails.idUser = response.id;
            });
            this.userModel.restaurantRegister(restaurantDetails, (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                res.json({ id: response.id, name: name, email: email, role: 'restaurant', token: token, messagge: response.success });
            });
        });
        this.getRestaurantInformationByIdUser = (req, res) => __awaiter(this, void 0, void 0, function* () {
            const { idUser } = req.body;
            if (!idUser) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof idUser != "string") {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (idUser.length <= 1) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.userModel.getRestaurantInformationByIdUser(idUser, (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                res.json({ latitude: response.latitude, longitude: response.longitude, address: response.address, messagge: response.success });
            });
        });
        this.login = (req, res) => {
            const { email, password } = req.body;
            if (!email || !password) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof email !== 'string' || typeof password !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (email.length <= 1 || password.length <= 1) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.userModel.login(email, password, (response) => {
                if (response.error) {
                    return res.status(401).json({ error: response.error });
                }
                let token = this.generateToken(response.id, email, response.name, response.role);
                res.status(200).json({ id: response.id, name: response.name, email: email, role: response.role, token: token, messagge: response.success });
            });
        };
        this.registerBiometric = (req, res) => {
            const { email, password, token } = req.body;
            if (!token) {
                return res.status(400).send({ error: 'Missing token' });
            }
            let decodedToken;
            try {
                decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
            }
            catch (_a) {
                return res.status(401).send({
                    error: 'Invalid token'
                });
            }
            if (!decodedToken.id || !decodedToken.email || !decodedToken.name) {
                return res.status(401).send({
                    error: 'Invalid token'
                });
            }
            if (email != decodedToken.email) {
                return res.status(402).send({
                    error: 'Email or password incorrect'
                });
            }
            const generatedToken = jwt.sign({ id: decodedToken.id, email: email }, process.env.TOKEN_KEY);
            this.userModel.registerBiometric(email, password, generatedToken, (response) => {
                if (response.error) {
                    if (response.message) {
                        return res.status(409).json({ error: response.message });
                    }
                    if (response.error == 'Email or password incorrect') {
                        return res.status(402).send({
                            error: 'Email or password incorrect'
                        });
                    }
                    return res.status(400).json({ error: response.error });
                }
                if (response.success) {
                    return res.status(200).json({ token: generatedToken });
                }
            });
        };
        this.biometricLogin = (req, res) => {
            const { biometricToken } = req.body;
            this.userModel.biometricLogin(biometricToken, (response) => {
                if (response.error) {
                    return res.status(401).json({ error: response.error });
                }
                let token = this.generateToken(response.id, response.email, response.name, response.role);
                res.status(200).json({ id: response.id, name: response.name, email: response.email, token: token, messagge: response.success });
            });
        };
        this.removeBiometric = (req, res) => {
            const { biometricToken } = req.body;
            this.userModel.removeBiometricLogin(biometricToken, (remove) => {
                if (remove.deletedCount == 1) {
                    return res.status(200).send();
                }
                return res.status(401).send();
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
                    return res.status(401).send({
                        error: 'Invalid token'
                    });
                }
                if (!decodedToken.id || !decodedToken.email || !decodedToken.name || !decodedToken.role) {
                    return res.status(401).send({
                        error: 'Invalid token'
                    });
                }
                return res.status(200).send({ role: decodedToken.role, message: 'Token valid' });
            }
            return res.status(400).send({
                error: 'Missin data'
            });
        };
        this.userModel = new userModel_1.default();
    }
    generateToken(id, email, name, role) {
        const token = jwt.sign({ id: id, email: email, name: name, role: role }, process.env.TOKEN_KEY, { expiresIn: "7d" });
        return token;
    }
}
exports.default = UserController;
