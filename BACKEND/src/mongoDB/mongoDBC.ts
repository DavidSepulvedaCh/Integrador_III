import mongoose from "mongoose";
import UserSchema from "./schemas/userSchema";
import OfferSchema from "./schemas/offerSchema";
import FavoriteSchema from "./schemas/favoriteSchema";
import biometricLoginUserData from "./schemas/biometricLoginUserData";
import dotenv from "dotenv";

class MongoDBC {

    private uri: string;
    public UserSchema: any;
    public OfferSchema: any;
    public FavoriteSchema: any;
    public BiometricLoginUserDataSchema: any;
    constructor() {
        dotenv.config();
        this.uri = `mongodb+srv://${process.env.USER}:${process.env.PASS}@cluster0.a87koto.mongodb.net/${process.env.DBNAME}?retryWrites=true&w=majority`;
        this.UserSchema = UserSchema;
        this.OfferSchema = OfferSchema;
        this.FavoriteSchema = FavoriteSchema;
        this.BiometricLoginUserDataSchema = biometricLoginUserData;
    }

    public connection(){
        mongoose.connect(this.uri)
            .then(() => {console.log('DB: Mongo connection');})
            .catch((err) => {console.log('Error connecting MongoDB: ', err)})
    }
}

export default MongoDBC;