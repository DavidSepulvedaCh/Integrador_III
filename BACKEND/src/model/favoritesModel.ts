import MongoDBC from "../mongoDB/mongoDBC";
import FavoriteSchema from "../mongoDB/schemas/favoriteSchema";

class FavoritesModel {

    private MongoDBC: MongoDBC;

    constructor() {
        this.MongoDBC = new MongoDBC();
    }

    public addFavorite = async (id_user: string, id_offer: string, fn: Function) => {
        this.MongoDBC.connection();
        let favoriteDetails = new FavoriteSchema({
            id_user: id_user,
            id_offer: id_offer
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

    public removeFavorite = async (id_user: string, id_offer: string, fn: Function) => {
        this.MongoDBC.connection();
        const deleteFavorite = await this.MongoDBC.FavoriteSchema.deleteOne(
            {
                id_user: id_user,
                id_offer: id_offer
            }
        );
        fn(deleteFavorite);
    }

    public getFavorites = async (id_user: string, fn: Function) => {
        this.MongoDBC.connection();
        const favorites = await this.MongoDBC.FavoriteSchema.find(
            {
                id_user: { $eq: id_user }
            }
        )
        fn(favorites);
    }

    public favoriteExists = async (id_user: string, id_offer: String): Promise<boolean> => {
        this.MongoDBC.connection();
        const favorite = await this.MongoDBC.FavoriteSchema.find(
            {
                
                id_offer: { $eq: id_offer }
            }
        );
        if (favorite.length > 0) {
            return true;
        }
        return false;
    }

}

export default FavoritesModel;