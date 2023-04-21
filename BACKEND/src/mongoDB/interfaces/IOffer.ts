import { Document } from "mongoose";

export default interface IOffer extends Document {
    address: String,
    latitude: String,
    longitude: String,
    name: String, 
    description: String, 
    photo: String, 
    price: Number, 
    idSeller: String, 
    city: String, 
    date: Date,
    active: Boolean
}
