"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const offerModel_1 = __importDefault(require("../model/offerModel"));
class OfferController {
    constructor() {
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
                return res.json({ offer: response.offer });
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
            const { address, name, description, photo, id_seller, city } = req.body;
            let { price } = req.body;
            if (!address || !name || !description || !photo || !price || !id_seller || !city) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            price = Number(price);
            if (typeof address !== 'string' || typeof name !== 'string' || typeof description !== 'string' || typeof photo !== 'string' || Number.isNaN(price) || typeof id_seller !== 'string' || typeof city !== 'string') {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            if (address.length <= 1 || name.length <= 1 || description.length <= 1 || photo.length <= 1 || id_seller.length <= 1 || city.length <= 1 || price < 1) {
                return res.status(400).send({
                    error: 'Invalid data'
                });
            }
            this.offerModel.register(address, name, description, photo, price, id_seller, city, (response) => {
                if (response.error) {
                    return res.status(409).json({ error: response.error });
                }
                res.json({ messagge: response.success });
            });
        };
        this.offerModel = new offerModel_1.default();
    }
}
exports.default = OfferController;
