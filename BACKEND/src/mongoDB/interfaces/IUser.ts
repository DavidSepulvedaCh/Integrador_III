import { Document } from "mongoose";

export default interface IUser extends Document {
    email: String,
    name: String,
    password: String
}