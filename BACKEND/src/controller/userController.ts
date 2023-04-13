import { Request, response, Response } from "express";
import UserModel from "../model/userModel";
import bcryptjs from "bcryptjs";
const jwt = require('jsonwebtoken');

class UserController {

    private userModel: UserModel;

    constructor() {
        this.userModel = new UserModel();
    }

    public personRegister = async (req: Request, res: Response) => {
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
        const passwordEncrypt: String = await bcryptjs.hash(password, 8);
        this.userModel.register(email, name, passwordEncrypt, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            let token = this.generateToken(response.id, email, name, 'person');
            res.json({ id: response.id, name: name, email: email, role: 'person', token: token, messagge: response.success });
        });
    }

    public login = (req: Request, res: Response) => {
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
        this.userModel.login(email, password, (response: any) => {
            if (response.error) {
                return res.status(401).json({ error: response.error });
            }
            let token = this.generateToken(response.id, email, response.name, response.role);
            res.status(200).json({ id: response.id, name: response.name, email: email, role: response.role, token: token, messagge: response.success });
        });
    }

    public registerBiometric = (req: Request, res: Response) => {
        const { email, password, token } = req.body;
        if (!token) {
            return res.status(400).send({ error: 'Missing token' });
        }
        let decodedToken: any;
        try {
            decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
        } catch {
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
        const generatedToken = jwt.sign(
            { id: decodedToken.id, email: email },
            process.env.TOKEN_KEY
        );
        this.userModel.registerBiometric(email, password, generatedToken, (response: any) => {
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
    }

    public biometricLogin = (req: Request, res: Response) => {
        const { biometricToken } = req.body;
        this.userModel.biometricLogin(biometricToken, (response: any) => {
            if (response.error) {
                return res.status(401).json({ error: response.error });
            }
            let token = this.generateToken(response.id, response.email, response.name, response.role);
            res.status(200).json({ id: response.id, name: response.name, email: response.email, token: token, messagge: response.success });
        });
    }

    public removeBiometric = (req: Request, res: Response) => {
        const { biometricToken } = req.body;
        this.userModel.removeBiometricLogin(biometricToken, (remove: any) => {
            if(remove.deletedCount == 1){
                return res.status(200).send();
            }
            return res.status(401).send();
        });
    }

    private generateToken(id: string, email: string, name: string, role: string) {
        const token = jwt.sign(
            { id: id, email: email, name: name, role: role },
            process.env.TOKEN_KEY,
            { expiresIn: "7d" }
        );
        return token;
    }

    public isLogged = (req: Request, res: Response) => {
        const token = req.body.token;
        if (token) {
            let decodedToken: any;
            try {
                decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
            } catch {
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
    }
}

export default UserController;