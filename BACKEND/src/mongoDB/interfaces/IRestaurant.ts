import { Document } from "mongoose";

export default interface IRestaurant extends Document {
    idUser: String,
    photo: String,
    description: String,
    latitude: String,
    longitude: String,
    address: String,
    city: String
}