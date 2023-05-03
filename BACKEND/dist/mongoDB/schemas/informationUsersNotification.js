"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const mongoose_1 = require("mongoose");
const InformationUsersNotification = new mongoose_1.Schema({
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
exports.default = (0, mongoose_1.model)('informationUsersNotification', InformationUsersNotification);
