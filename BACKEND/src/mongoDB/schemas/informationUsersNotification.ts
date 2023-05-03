import { Schema, model } from "mongoose";
import IInformationUsersNotification from "../interfaces/IInformationUsersNotification";

const InformationUsersNotification = new Schema({
    idUser: {
        type: String,
        required: true
    },
    token: {
        type: String,
        required: true,
        unique: true
    }
});

export default model<IInformationUsersNotification>('informationUsersNotification', InformationUsersNotification);