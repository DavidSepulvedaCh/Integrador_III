"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const foodhub_d4f82_firebase_adminsdk_dk9h9_dfc047aee4_json_1 = __importDefault(require("./foodhub-d4f82-firebase-adminsdk-dk9h9-dfc047aee4.json"));
class FirebaseConnect {
    constructor() {
        this.admin = require("firebase-admin");
        this.serviceAccount = foodhub_d4f82_firebase_adminsdk_dk9h9_dfc047aee4_json_1.default;
    }
    initializeApp() {
        this.admin.initializeApp({
            credential: this.admin.credential.cert(this.serviceAccount)
        }).then(() => console.log("Firebase: Initialize app"));
    }
}
exports.default = FirebaseConnect;
