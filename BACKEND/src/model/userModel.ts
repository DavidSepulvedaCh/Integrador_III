import MongoDBC from "../mongoDB/mongoDBC";
import UserSchema from "../mongoDB/schemas/userSchema";
import biometricLoginUserData from "../mongoDB/schemas/biometricLoginUserData";
import bcryptjs from "bcryptjs";
import IRestaurant from "../mongoDB/interfaces/IRestaurant";

class UserModel {

    private MongoDBC: MongoDBC;

    constructor() {
        this.MongoDBC = new MongoDBC();
    }

    public register = async (email: String, name: String, password: String, role: String, fn: Function) => {
        this.MongoDBC.connection();
        let userDetails = new UserSchema({
            email: email,
            name: name,
            password: password,
            role: role
        });
        const userExists = await this.MongoDBC.UserSchema.findOne(
            {
                email: { $eq: email }
            }
        );
        if (userExists != null) {
            return fn({
                error: 'Email already exists'
            });
        }
        const newUser = await userDetails.save();
        if (newUser._id) {
            return fn({
                success: 'Register success',
                id: newUser._id
            })
        }
        return fn({
            error: 'Register error'
        });
    }

    public login = async (email: string, password: string, fn: Function) => {
        this.MongoDBC.connection();
        const userExists = await this.MongoDBC.UserSchema.findOne(
            {
                email: { $eq: email }
            }
        );
        if (userExists == null) {
            return fn({
                error: 'Email or password incorrect'
            });
        }
        let compare = bcryptjs.compareSync(password, userExists.password);
        if (!compare) {
            return fn({
                error: 'Email or password incorrect'
            });
        }
        return fn({
            success: 'Login success',
            id: userExists._id,
            email: email,
            name: userExists.name,
            role: userExists.role
        });
    }

    public getUserById = async (id: string): Promise<boolean> => {
        try {
            const userExists = await this.MongoDBC.UserSchema.findById(id);
            return true;
        } catch (error) {
            return false;
        }
    }

    public registerBiometric = async (email: string, password: string, token: string, fn: Function) => {
        this.MongoDBC.connection();
        const userExists = await this.MongoDBC.UserSchema.findOne(
            {
                email: { $eq: email }
            }
        );
        if (userExists == null) {
            return fn({
                error: 'Email or password incorrect'
            });
        }
        let compare = bcryptjs.compareSync(password, userExists.password);
        if (!compare) {
            return fn({
                error: 'Email or password incorrect'
            });
        }
        let biometricLoginUserDataDetails = new biometricLoginUserData({
            email: email,
            password: userExists.password,
            token: token
        });
        try {
            const newUser = await biometricLoginUserDataDetails.save();
            if (newUser._id) {
                return fn({
                    success: 'Register success'
                });
            }
        } catch (error) {
            return fn({
                error: error,
                message: 'Token already exists'
            });
        }
        return fn({
            error: 'Register error'
        });
    }

    public biometricLogin = async (token: string, fn: Function) => {
        this.MongoDBC.connection();
        const userExistsToken = await this.MongoDBC.BiometricLoginUserDataSchema.findOne(
            {
                token: { $eq: token }
            }
        );
        const userExists = await this.MongoDBC.UserSchema.findOne(
            {
                email: { $eq: userExistsToken.email }
            }
        );
        if (userExists == null) {
            return fn({
                error: 'Email or password incorrect'
            });
        }
        return fn({
            success: 'Login success',
            id: userExists._id,
            email: userExists.email,
            name: userExists.name,
            role: userExists.role
        });
    }

    public removeBiometricLogin = async (token: string, fn: Function) => {
        this.MongoDBC.connection();
        const userExists = await this.MongoDBC.BiometricLoginUserDataSchema.findOne(
            {
                token: { $eq: token }
            }
        );
        if(userExists){
            const remove = await this.MongoDBC.BiometricLoginUserDataSchema.deleteOne(
                {
                    token: { $eq: token }
                }
            );
            fn(remove);
        }
    }

    public restaurantRegister = async (restaurantDetails: IRestaurant, fn: Function) => {
        this.MongoDBC.connection();
        const userExists = await this.MongoDBC.UserSchema.findById(restaurantDetails.idUser);
        if (userExists == null) {
            return fn({
                error: 'User does not exist'
            });
        }
        const newRestaurant = await restaurantDetails.save();
        if (newRestaurant._id) {
            return fn({
                success: 'Register success'
            })
        }
        return fn({
            error: 'Register error'
        });
    }

    public getRestaurantInformationByIdUser = async (idUser: String, fn: Function) => {
        this.MongoDBC.connection();
        const restaurantExists = await this.MongoDBC.RestaurantSchema.findOne(
            {
                idUser: { $eq: idUser }
            }
        );
        if (restaurantExists == null) {
            return fn({
                error: 'User does not exist'
            });
        }
        return fn({
            success: 'Login success',
            latitude: restaurantExists.latitude,
            longitude: restaurantExists.longitude,
            address: restaurantExists.address
        });
    }

}

export default UserModel;