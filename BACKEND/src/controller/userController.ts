import { Request, response, Response } from "express";
import UserModel from "../model/userModel";
import bcryptjs from "bcryptjs";
import restaurantSchema from "../mongoDB/schemas/restaurantSchema";
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
        this.userModel.register(email, name, passwordEncrypt, "person", (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            let token = this.generateToken(response.id, email, name, 'person');
            res.json({ id: response.id, name: name, email: email, role: 'person', token: token, messagge: response.success });
        });
    }

    public restaurantRegister = async (req: Request, res: Response) => {
        const { email, name, password, latitude, longitude, address, city } = req.body;
        if (!email || !name || !password || !latitude || !longitude || !city) {
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if (typeof email !== 'string' || typeof name !== 'string' || typeof password !== 'string' || typeof latitude !== 'string' || typeof longitude !== 'string' || typeof city !== 'string') {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        if (email.length <= 1 || name.length <= 1 || password.length <= 1 || latitude.length <= 1 || longitude.length <= 1 || city.length <= 1) {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        const passwordEncrypt: String = await bcryptjs.hash(password, 8);
        let restaurantDetails = new restaurantSchema({
            idUser: '',
            description: '',
            latitude: latitude,
            longitude: longitude,
            address: address,
            city: city
        });
        let token: String;
        try {
            await this.userModel.register(email, name, passwordEncrypt, "restaurant", (response: any) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                token = this.generateToken(response.id, email, name, 'restaurant');
                restaurantDetails.idUser = response.id;
            });
            this.userModel.restaurantRegister(restaurantDetails, (response: any) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                res.json({ id: restaurantDetails.idUser, name: name, email: email, role: 'restaurant', token: token, messagge: response.success });
            });
        } catch (error) {
            console.log(error);
        }

    }

    public getRestaurantInformationByIdUser = async (req: Request, res: Response) => {
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
        this.userModel.getRestaurantInformationByIdUser(idUser, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            res.json({ photo: response.photo, description: response.description, latitude: response.latitude, longitude: response.longitude, address: response.address, city: response.city, messagge: response.success });
        });
    }

    public getInformationAllRestaurants = async (req: Request, res: Response) => {
        this.userModel.getInformationAllRestaurants((response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            res.status(200).send();
        });
    }

    public updateRestaurantName = async (req: Request, res: Response) => {
        const { idUser, name } = req.body;
        if (!idUser || !name) {
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if (typeof idUser != "string" || typeof name != "string") {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        if (idUser.length <= 1 || name.length <= 1) {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.userModel.updateRestaurantName(idUser, name, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            res.status(200).send({ success: "Update successful" });
        });
    }

    public updatePhoto = async (req: Request, res: Response) => {
        const { id, photo } = req.body;
        if (!id || !photo) {
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if (typeof id != "string" || typeof photo != "string") {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        if (id.length <= 1 || photo.length <= 1) {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.userModel.updatePhoto(id, photo, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            res.status(200).send({ success: "Update successful" });
        });
    }

    public updateRestaurantDescription = async (req: Request, res: Response) => {
        const { idUser, description } = req.body;
        if (!idUser || !description) {
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if (typeof idUser != "string" || typeof description != "string") {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        if (idUser.length <= 1 || description.length <= 1) {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.userModel.updateRestaurantDescription(idUser, description, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            res.status(200).send({ success: "Update successful" });
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
            res.status(200).json({ id: response.id, name: response.name, email: email, photo: response.photo, role: response.role, token: token, messagge: response.success });
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
            if (remove.deletedCount == 1) {
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
    }
}

export default UserController;