import IFavorite from "mongoDB/interfaces/IFavorite";
import { Schema, model } from "mongoose";

const FavoriteSchema = new Schema({
    id_user: {
        type: String,
        required: true
    },
    id_offer: {
        type: String,
        required: true
    }
});

export default model<IFavorite>('favorites', FavoriteSchema);