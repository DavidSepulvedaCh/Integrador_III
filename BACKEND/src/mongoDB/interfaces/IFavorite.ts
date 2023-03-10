import { Document } from "mongoose";

export default interface IFavorite extends Document {
    idUser: String,
    idOffer: String
}
