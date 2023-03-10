import IFavorite from "mongoDB/interfaces/IFavorite";
import { Schema, model } from "mongoose";

const FavoriteSchema = new Schema({
    idUser: {
        type: String,
        required: true
    },
    idOffer: {
        type: String,
        required: true
    }
});

export default model<IFavorite>('favorites', FavoriteSchema);