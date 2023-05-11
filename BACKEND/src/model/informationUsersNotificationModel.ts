import MongoDBC from "../mongoDB/mongoDBC";
import InformationUsersNotification from "../mongoDB/schemas/informationUsersNotification";
import FavoritesModel from "../model/favoritesModel";
import FirebaseConnect from "../firebase/firebaseConnect";

class InformationUsersNotificationModel {

    private MongoDBC: MongoDBC;
    private favoritesModel: FavoritesModel;
    private firebaseConnect: FirebaseConnect;

    constructor() {
        this.MongoDBC = new MongoDBC();
        this.favoritesModel = new FavoritesModel();
        this.firebaseConnect = new FirebaseConnect();
    }

    public add = async (idUser: string, token: string, fn: Function) => {
        try {
            this.MongoDBC.connection();
            const existingUser = await this.MongoDBC.InformationUsersNotification.findOne({ token: { $eq: token } });
            if (existingUser) {
                // If a document already exists for the provided token, update idUser
                existingUser.idUser = idUser;
                const updateUser = await existingUser.save();
                if (updateUser) {
                    return fn({
                        success: 'Update success',
                        id: existingUser._id
                    });
                } else {
                    return fn({
                        error: 'Update error'
                    });
                }

            } else {
                // If there is no existing document, create a new one
                let userNotificationDetails = new InformationUsersNotification({
                    idUser: idUser,
                    token: token
                });
                const newUser = await userNotificationDetails.save();
                if (newUser._id) {
                    return fn({
                        success: 'Register success',
                        id: newUser._id
                    });
                } else {
                    return fn({
                        error: 'Register error'
                    });
                }
            }
        } catch (error) {
            console.error(error);
            return fn({
                error: 'Register error'
            });
        }
    }

    public remove = async (token: string, fn: Function) => {
        try {
            this.MongoDBC.connection();
            const deletedUser = await this.MongoDBC.InformationUsersNotification.findOneAndDelete({ token: { $eq: token } });
            if (deletedUser) {
                return fn({
                    success: 'Delete success'
                });
            } else {
                return fn({
                    error: "Doesn't exists a register with that token"
                });
            }
        } catch (error) {
            return fn({
                error: 'Delete error'
            });
        }
    }

    public sendNotification = async (idRestaurant: string, restaurantName: string, offerName: string) => {
        try {
            const userIds = await this.favoritesModel.getIdsUsersHaveRestaurantFavorite(idRestaurant);
            this.MongoDBC.connection();
            const ids = userIds.map((register: any) => register.idUser);
            const tokens = await this.MongoDBC.InformationUsersNotification.find({ idUser: { $in: ids } });
            const tokensArray = tokens.map((register: any) => register.token);
            if (tokensArray.length == 0) {
                return;
            }
            const message = {
                data: {
                    idRestaurant: idRestaurant
                },
                notification: {
                    title: "¡Nueva oferta disponible!",
                    body: `El restaurante ${restaurantName} ha publicado una nueva oferta: ${offerName}`,
                },
                tokens: tokensArray,
            };
            const response = await this.firebaseConnect.admin.messaging().sendMulticast(message);
            console.log(`Notificaciones enviadas: ${response.successCount}`);
            return;
        } catch (error) {
            console.log("Error sendNotification: " + error);
        }
    }
}

export default InformationUsersNotificationModel;