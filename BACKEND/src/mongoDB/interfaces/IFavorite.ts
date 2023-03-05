import { Document } from "mongoose";

export default interface IFavorite extends Document {
    id_user: String,
    id_offer: String
}
