"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const FavoriteSchema = new mongoose_1.Schema({
    id_user: {
        type: String,
        required: true
    },
    id_offer: {
        type: String,
        required: true
    }
});
exports.default = (0, mongoose_1.model)('favorites', FavoriteSchema);
