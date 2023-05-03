import { Document } from "mongoose";

export default interface IInformationUsersNotification extends Document {
    idUser: String,
    token: String
}
