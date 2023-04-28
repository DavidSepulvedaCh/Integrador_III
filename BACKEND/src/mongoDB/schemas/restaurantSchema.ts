import { Schema, model } from "mongoose";
import IRestaurant from "../interfaces/IRestaurant";

const RestaurantSchema = new Schema({
    idUser: {
        type: String,
        required: true,
        unique: true
    },
    photo: {
        type: String,
        required: true
    },
    description: {
        type: String,
        required: true
    },
    latitude: {
        type: String,
        required: true
    },
    longitude: {
        type: String,
        required: true
    },
    address: {
        type: String,
        required: true
    },
    city: {
        type: String,
        required: true
    }
});

export default model<IRestaurant>('restaurants', RestaurantSchema);