import { Request, Response } from "express";
import FavoritesModel from "../model/favoritesModel";
import OfferModel from "../model/offerModel";
import UserModel from "../model/userModel";

class FavoriteController {

    private favoritesModel: FavoritesModel;
    private userModel: UserModel;
    private offerModel: OfferModel;

    constructor() {
        this.favoritesModel = new FavoritesModel();
        this.userModel = new UserModel();
        this.offerModel = new OfferModel();
    }

    public addFavorite = async (req: Request, res: Response) => {
        const { id_user, id_offer } = req.body;
        if(!id_user || !id_offer){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof id_user !== 'string' || typeof id_offer !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var favoriteExists: boolean = await this.favoritesModel.favoriteExists(id_user, id_offer);
        if(favoriteExists){
            return res.status(400).send({
                error: 'Favorite already exists'
            });
        }
        var userExists: boolean = await this.userModel.getUserById(id_user);
        if(!userExists){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var offerExists: boolean = await this.offerModel.offerExists(id_offer);
        if(!offerExists){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.favoritesModel.addFavorite(id_user, id_offer, (response: any) => {
            if(response.error){
                return res.status(400).send({
                    error: response.error
                });
            }
            return res.status(200).json({id: response.id});
        });
    }

    public removeFavorite = async (req: Request, res: Response) => {
        const { id_user, id_offer } = req.body;
        if(!id_user || !id_offer){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof id_user !== 'string' || typeof id_offer !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var favoriteExists: boolean = await this.favoritesModel.favoriteExists(id_user, id_offer);
        if(!favoriteExists){
            return res.status(400).send({
                error: 'Favorite no exists'
            });
        }
        this.favoritesModel.removeFavorite(id_user, id_offer, (response: any) => {
            if(response.deletedCount != 1){
                return res.status(400).send({
                    error: response.error
                });
            }
            return res.status(200).json({response: response});
        });
    }

    public getFavorites = async (req: Request, res: Response) => {
        const { id_user } = req.body;
        if(!id_user){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof id_user !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var ids_offers: any;
        await this.favoritesModel.getFavorites(id_user, (response: any) => {
            ids_offers = response.map((element: { id_offer: any; }) => element.id_offer);
        });
        if(ids_offers.length == 0){
            return res.status(200).json({offers: ids_offers});
        }
        this.offerModel.getByIds(ids_offers, (response: any) => {
            return res.status(200).send(response);
        });
    }
}

export default FavoriteController;