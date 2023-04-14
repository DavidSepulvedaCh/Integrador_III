import MongoDBC from "../mongoDB/mongoDBC";
import OfferSchema from "../mongoDB/schemas/offerSchema";

class OfferModel {

    private MongoDBC: MongoDBC;

    constructor() {
        this.MongoDBC = new MongoDBC();
    }

    public getById = async (id: string, fn: Function) => {
        this.MongoDBC.connection();
        try {
            let offer = await this.MongoDBC.OfferSchema.findById(id);
            return fn({
                offer: offer
            });
        } catch (error) {
            return fn({
                error: 'Invalid id'
            });
        }
    }

    public getOffers = async (fn: Function) => {
        this.MongoDBC.connection();
        const products = await this.MongoDBC.OfferSchema.find();
        fn(products);
    }

    public getByIds = async (idsList: string, fn: Function) => {
        this.MongoDBC.connection();
        let offer = await this.MongoDBC.OfferSchema.find(
            {
                _id: { $in: idsList }
            }
        );
        return fn({
            offers: offer
        });
    }

    public getByCity = async (city: string, fn: Function) => {
        this.MongoDBC.connection();
        const products = await this.MongoDBC.OfferSchema.find(
            {
                city: { $eq: city }
            }
        );
        fn(products);
    }

    public register = async (address: string, name: string, description: string, photo: string, price: number, idSeller: string, city: string, fn: Function) => {
        this.MongoDBC.connection();
        let offerDetails = new OfferSchema({
            address: address, name: name, description: description, photo: photo, price: price, idSeller: idSeller, city: city
        });
        try {
            await this.MongoDBC.UserSchema.findById(idSeller);
        } catch (error) {
            return fn({
                error: 'Invalid id'
            });
        }
        const newOffer = await offerDetails.save();
        if (newOffer._id) {
            return fn({
                success: 'Register success',
                id: newOffer._id
            });
        }
        return fn({
            error: 'Register error'
        });
    }

    public offerExists = async (id: string): Promise<boolean> => {
        try {
            const offerExists = await this.MongoDBC.OfferSchema.findById(id);
            return true;
        } catch (error) {
            return false;
        }
    }

    public getMaxPriceAllOffers = async (fn: Function) => {
        this.MongoDBC.connection();
        const cursor = await this.MongoDBC.OfferSchema.aggregate([
            { $group: { _id: null, maxPrice: { $max: "$price" } } }
        ]);
        let maxPrice = -Infinity;
        for await (const result of cursor) {
            maxPrice = result.maxPrice;
        }
        return fn({
            maxPrice: maxPrice
        });
    }

    public getByPriceRange = async (minPrice: number, maxPrice: number, fn: Function) => {
        this.MongoDBC.connection();
        let offers = await this.MongoDBC.OfferSchema.find(
            { price: { $gte: minPrice, $lte: maxPrice } }
        );
        fn(offers);
    }
}

export default OfferModel;