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
const jwt = require('jsonwebtoken');
class UserController {
    constructor() {
        this.register = (req, res) => __awaiter(this, void 0, void 0, function* () {
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
                let token = this.generateToken(response.id, email, name);
                res.json({ id: response.id, name: name, email: email, token: token, messagge: response.success });
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
                let token = this.generateToken(response.id, email, response.name);
                res.status(200).json({ id: response.id, name: response.name, email: email, token: token, messagge: response.success });
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
                if (!decodedToken.id || !decodedToken.email || !decodedToken.name) {
                    return res.status(401).send({
                        error: 'Invalid token'
                    });
                }
                return res.status(200).send({ message: 'Token valid' });
            }
            return res.status(400).send({
                error: 'Missin data'
            });
        };
        this.userModel = new userModel_1.default();
    }
    generateToken(id, email, name) {
        const token = jwt.sign({ id: id, email: email, name: name }, process.env.TOKEN_KEY, { expiresIn: "7d" });
        console.log(token);
        return token;
    }
}
exports.default = UserController;
