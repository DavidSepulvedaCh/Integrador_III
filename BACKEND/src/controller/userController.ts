import { Request, response, Response } from "express";
import UserModel from "../model/userModel";
import bcryptjs from "bcryptjs";
const jwt = require('jsonwebtoken');

class UserController {

    private userModel: UserModel;

    constructor() {
        this.userModel = new UserModel();
    }

    public register = async (req: Request, res: Response) => {
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
        const passwordEncrypt: String = await bcryptjs.hash(password, 8);
        this.userModel.register(email, name, passwordEncrypt, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            let token = this.generateToken(response.id, email, name);
            res.json({ id: response.id, name: name, email: email, token: token, messagge: response.success });
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
            let token = this.generateToken(response.id, email, response.name);
            res.status(200).json({ id: response.id, name: response.name, email: email, token: token, messagge: response.success });
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
            { email: email },
            process.env.TOKEN_KEY
        );
        console.log('Before register');
        this.userModel.registerBiometric(email, password, generatedToken, (response: any) => {
            if (response.error) {
                console.log('Inside error');
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
        const { token } = req.body;
        this.userModel.biometricLogin(token, (response: any) => {
            if (response.error) {
                return res.status(401).json({ error: response.error });
            }
            let token = this.generateToken(response.id, response.email, response.name);
            res.status(200).json({ id: response.id, name: response.name, email: response.email, token: token, messagge: response.success });
        });
    }

    public pruebaBiometricToken = (req: Request, res: Response) => {
        const { email, password, token } = req.body;
        this.userModel.pruebaBiometricLogin(email, password, token, (response: any) => {
            if (response.error) {
                return res.status(401).json({ error: response.error });
            }
            return res.status(200).json({ id: response.id });
        });
    }

    public removeBiometric = (req: Request, res: Response) => {
        const { token } = req.body;
        
    }

    private generateToken(id: string, email: string, name: string) {
        const token = jwt.sign(
            { id: id, email: email, name: name },
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