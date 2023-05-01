"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const FavoriteSchema = new mongoose_1.Schema({
    idUser: {
        type: String,
        required: true
    },
    idRestaurant: {
        type: String,
        required: true
    }
});
exports.default = (0, mongoose_1.model)('favorites', FavoriteSchema);
