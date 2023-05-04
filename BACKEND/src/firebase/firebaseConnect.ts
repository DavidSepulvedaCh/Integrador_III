import key from "./foodhub-d4f82-firebase-adminsdk-dk9h9-dfc047aee4.json";

class FirebaseConnect {

    public admin: any;
    private serviceAccount: any;

    constructor() {
        this.admin = require("firebase-admin");
        this.serviceAccount = key;
        this.start();
    }

    public start() {
        if (!this.admin.apps.length) {
            this.admin.initializeApp({
                credential: this.admin.credential.cert(this.serviceAccount)
            });
        } else {
            this.admin.app().delete();
            this.admin.initializeApp({
                credential: this.admin.credential.cert(this.serviceAccount)
            });
        }
    }
}

export default FirebaseConnect;