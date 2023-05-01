import MongoDBC from "../mongoDB/mongoDBC";
import FavoriteSchema from "../mongoDB/schemas/favoriteSchema";

class FavoritesModel {

    private MongoDBC: MongoDBC;

    constructor() {
        this.MongoDBC = new MongoDBC();
    }

    public addFavorite = async (idUser: string, idRestaurant: string, fn: Function) => {
        this.MongoDBC.connection();
        let favoriteDetails = new FavoriteSchema({
            idUser: idUser,
            idRestaurant: idRestaurant
        });
        const newFavorite = await favoriteDetails.save();
        if (newFavorite._id) {
            return fn({
                success: 'Register success',
                id: newFavorite._id
            })
        }
        return fn({
            error: 'Register error'
        });
    }

    public removeFavorite = async (idUser: string, idRestaurant: string, fn: Function) => {
        this.MongoDBC.connection();
        const deleteFavorite = await this.MongoDBC.FavoriteSchema.deleteOne(
            {
                idUser: idUser,
                idRestaurant: idRestaurant
            }
        );
        fn(deleteFavorite);
    }

    public getFavorites = async (idUser: string, fn: Function) => {
        this.MongoDBC.connection();
        const favorites = await this.MongoDBC.FavoriteSchema.find(
            {
                idUser: { $eq: idUser }
            }
        )
        fn(favorites);
    }

    public favoriteExists = async (idUser: string, idRestaurant: String): Promise<boolean> => {
        this.MongoDBC.connection();
        const favorite = await this.MongoDBC.FavoriteSchema.find(
            {
                idRestaurant: { $eq: idRestaurant }
            }
        );
        if (favorite.length > 0) {
            return true;
        }
        return false;
    }

}

export default FavoritesModel;