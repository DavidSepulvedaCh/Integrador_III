"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const offerModel_1 = __importDefault(require("../model/offerModel"));
const informationUsersNotificationModel_1 = __importDefault(require("../model/informationUsersNotificationModel"));
const jwt = require('jsonwebtoken');
class OfferController {
    constructor() {
        this.getByListIds = (req, res) => {
            const { idsOffers } = req.body;
            if (!idsOffers) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            this.offerModel.getByIds(idsOffers, (response) => {
                return res.status(200).send(response);
            });
        };
        this.getById = (req, res) => {
            const { id } = req.body;
            if (!id) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof id !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.offerModel.getById(id, (response) => {
                if (response.error) {
                    return res.status(400).send({
                        error: response.error
                    });
                }
                return res.status(200).json({ offer: response.offer });
            });
        };
        this.getOffers = (req, res) => {
            this.offerModel.getOffers((products) => {
                res.status(200).json(products);
            });
        };
        this.getByCity = (req, res) => {
            const { city } = req.body;
            if (!city) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof city !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.offerModel.getByCity(city, (response) => {
                res.json(response);
            });
        };
        this.register = (req, res) => {
            const { address, latitude, longitude, name, description, photo, city } = req.body;
            let idSeller = '';
            let restaurantName = "";
            const token = req.body.token;
            if (token) {
                let decodedToken;
                try {
                    decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
                }
                catch (_a) {
                    return res.status(400).send({
                        error: 'Missing data'
                    });
                }
                if (!decodedToken.id) {
                    return res.status(400).send({
                        error: 'Missing data'
                    });
                }
                if (decodedToken.name) {
                    restaurantName = decodedToken.name;
                }
                idSeller = decodedToken.id;
            }
            else {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            let { price } = req.body;
            if (!address || !name || !description || !photo || !price || !idSeller || !city) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            price = Number(price);
            if (typeof address !== 'string' || typeof name !== 'string' || typeof description !== 'string' || typeof photo !== 'string' || Number.isNaN(price) || typeof idSeller !== 'string' || typeof city !== 'string' || typeof latitude !== 'string' || typeof longitude !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (address.length <= 1 || name.length <= 1 || description.length <= 1 || photo.length <= 1 || idSeller.length <= 1 || city.length <= 1 || price < 1 || latitude.length < 1 || longitude.length < 1) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.offerModel.register(address, latitude, longitude, name, description, photo, price, idSeller, city, (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                this.notificationModel.sendNotification(idSeller, restaurantName, name).then(() => {
                    res.status(200).json({ messagge: response.success });
                });
            });
        };
        this.getMaxPriceAllOffers = (req, res) => {
            this.offerModel.getMaxPriceAllOffers((response) => {
                return res.status(200).send(response);
            });
        };
        this.getByPriceRange = (req, res) => {
            const { minPrice, maxPrice } = req.body;
            this.offerModel.getByPriceRange(minPrice, maxPrice, (response) => {
                res.status(200).json(response);
            });
        };
        this.getByCityAndPriceRange = (req, res) => {
            const { city, minPrice, maxPrice } = req.body;
            if (!city) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof city !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.offerModel.getByCityAndPriceRange(city, minPrice, maxPrice, (response) => {
                res.json(response);
            });
        };
        this.getByIdUser = (req, res) => {
            const { idUser } = req.body;
            if (!idUser) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof idUser !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.offerModel.getByIdUser(idUser, (response) => {
                res.status(200).json(response);
            });
        };
        this.remove = (req, res) => {
            const { id } = req.body;
            if (!id) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (typeof id !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.offerModel.remove(id, (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                res.status(200).json(response);
            });
        };
        this.offerModel = new offerModel_1.default();
        this.notificationModel = new informationUsersNotificationModel_1.default();
    }
}
exports.default = OfferController;
