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
        const { idUser, idOffer } = req.body;
        if(!idUser || !idOffer){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof idUser !== 'string' || typeof idOffer !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var favoriteExists: boolean = await this.favoritesModel.favoriteExists(idUser, idOffer);
        if(favoriteExists){
            return res.status(410).send({
                error: 'Favorite already exists'
            });
        }
        var userExists: boolean = await this.userModel.getUserById(idUser);
        if(!userExists){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var offerExists: boolean = await this.offerModel.offerExists(idOffer);
        if(!offerExists){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        this.favoritesModel.addFavorite(idUser, idOffer, (response: any) => {
            if(response.error){
                return res.status(400).send({
                    error: response.error
                });
            }
            return res.status(200).json({id: response.id});
        });
    }

    public removeFavorite = async (req: Request, res: Response) => {
        const { idUser, idOffer } = req.body;
        if(!idUser || !idOffer){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof idUser !== 'string' || typeof idOffer !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var favoriteExists: boolean = await this.favoritesModel.favoriteExists(idUser, idOffer);
        if(!favoriteExists){
            return res.status(400).send({
                error: 'Favorite no exists'
            });
        }
        this.favoritesModel.removeFavorite(idUser, idOffer, (response: any) => {
            if(response.deletedCount != 1){
                return res.status(400).send({
                    error: response.error
                });
            }
            return res.status(200).json({response: response});
        });
    }

    public getFavorites = async (req: Request, res: Response) => {
        const { idUser } = req.body;
        if(!idUser){
            return res.status(400).send({
                error: 'Missing data'
            });
        }
        if(typeof idUser !== 'string'){
            return res.status(400).send({
                error: 'Invalid data'
            });
        }
        var ids_offers: any;
        await this.favoritesModel.getFavorites(idUser, (response: any) => {
            ids_offers = response.map((element: { idOffer: any; }) => element.idOffer);
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