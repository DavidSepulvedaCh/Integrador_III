import { Request, Response } from "express";
import OfferModel from "../model/offerModel";
const jwt = require('jsonwebtoken');

class OfferController {

    private offerModel: OfferModel

    constructor() {
        this.offerModel = new OfferModel();
    }

    public getByListIds = (req: Request, res: Response) => {
        const { idsOffers } = req.body;
        if (!idsOffers) {
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        this.offerModel.getByIds(idsOffers, (response: any) => {
            return res.status(200).send(response);
        });
    }


    public getById = (req: Request, res: Response) => {
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
        this.offerModel.getById(id, (response: any) => {
            if (response.error) {
                return res.status(400).send({
                    error: response.error
                });
            }
            return res.status(200).json({ offer: response.offer });
        });
    }

    public getOffers = (req: Request, res: Response) => {
        this.offerModel.getOffers((products: any) => {
            res.status(200).json(products);
        });
    }

    public getByCity = (req: Request, res: Response) => {
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
        this.offerModel.getByCity(city, (response: any) => {
            res.json(response);
        });
    }

    public register = (req: Request, res: Response) => {
        const { address, name, description, photo, city } = req.body;
        let idSeller = '';

        const token = req.body.token;
        if (token) {
            let decodedToken: any;
            try {
                decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
            } catch {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            if (!decodedToken.id) {
                return res.status(400).send({
                    error: 'Missing data'
                });
            }
            idSeller = decodedToken.id;
        } else {
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
        if (typeof address !== 'string' || typeof name !== 'string' || typeof description !== 'string' || typeof photo !== 'string' || Number.isNaN(price) || typeof idSeller !== 'string' || typeof city !== 'string') {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        if (address.length <= 1 || name.length <= 1 || description.length <= 1 || photo.length <= 1 || idSeller.length <= 1 || city.length <= 1 || price < 1) {
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.offerModel.register(address, name, description, photo, price, idSeller, city, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            res.json({ messagge: response.success });
        });
    }
}

export default OfferController;