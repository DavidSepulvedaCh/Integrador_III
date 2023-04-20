import { Document } from "mongoose";

export default interface IRestaurant extends Document {
    idUser: String,
    latitude: String,
    longitude: String,
    address: String
}