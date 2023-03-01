import { Request, Response } from "express";
import OfferModel from "../model/offerModel";

class OfferController {

    private offerModel: OfferModel

    constructor() {
        this.offerModel = new OfferModel();
    }

    public getById = (req: Request, res: Response) => {
        const { id } = req.body;
        if(!id){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof id !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.offerModel.getById(id, (response: any) => {
            if(response.error){
                return res.status(400).send({
                    error: response.error
                });
            }
            return res.json({offer: response.offer});
        });
    }

    public getByCity = (req: Request, res: Response) => {
        const { city } = req.body;
        if(!city){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof city !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.offerModel.getByCity(city, (response: any) => {
            res.json(response);
        });
    }

    public register = (req: Request, res: Response) => {
        const { address, name, description, photo, id_seller, city } = req.body;
        let { price } = req.body;
        if(!address || !name || !description || !photo || !price || !id_seller || !city){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        price = Number(price);
        if(typeof address !== 'string' || typeof name !== 'string' || typeof description !== 'string' || typeof photo !== 'string' || Number.isNaN(price) || typeof id_seller !== 'string' || typeof city !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        if(address.length <= 1 || name.length <= 1 || description.length <= 1 || photo.length <= 1 || id_seller.length <= 1 || city.length <= 1 || price < 1){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.offerModel.register(address, name, description, photo, price, id_seller, city, (response: any) => {
            if (response.error) {
                return res.status(409).json({ error: response.error });
            }
            res.json({ messagge: response.success });
        });
    }
}

export default OfferController;