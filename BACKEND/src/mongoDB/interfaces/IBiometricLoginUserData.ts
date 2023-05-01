import { Document } from "mongoose";

export default interface IBiometricLoginUserData extends Document {
    email: String,
    token: String
}
