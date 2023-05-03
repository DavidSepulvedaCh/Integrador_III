import key from "./foodhub-d4f82-firebase-adminsdk-dk9h9-dfc047aee4.json";

class FirebaseConnect {

    public admin: any; 
    private serviceAccount: any;

    constructor() {
        this.admin = require("firebase-admin");
        this.serviceAccount = key;
    }

    public initializeApp(){
        this.admin.initializeApp({
            credential: this.admin.credential.cert(this.serviceAccount)
        }).then(() => console.log("Firebase: Initialize app"));
    }
}

export default FirebaseConnect;