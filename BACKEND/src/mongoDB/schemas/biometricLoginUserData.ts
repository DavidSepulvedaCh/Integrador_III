import { Schema, model } from "mongoose";
import IBiometricLoginUserData from "../interfaces/IBiometricLoginUserData";

const BiometricLoginUserData = new Schema({
    email: {
        type: String,
        required: true
    },
    token: {
        type: String,
        required: true,
        unique: true
    }
});

export default model<IBiometricLoginUserData>('biometricLoginUserData', BiometricLoginUserData);