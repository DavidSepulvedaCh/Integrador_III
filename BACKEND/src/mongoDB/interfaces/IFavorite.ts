import { Document } from "mongoose";

export default interface IFavorite extends Document {
    idUser: String,
    idRestaurant: String
}
