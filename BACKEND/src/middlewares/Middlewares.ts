import { Request, Response } from "express";
import { unless } from "express-unless";
const jwt = require('jsonwebtoken');

function verifyToken(req: Request, res: Response, next: Function){
    const token = req.body.token;
    if (token) {
        let decodedToken: any;
        try {
            decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
        } catch {
            return res.status(403).send({
                error: 'Invalid token'
            });
        }
        if (!decodedToken.id || !decodedToken.email || !decodedToken.name) {
            return res.status(403).send({
                error: 'Invalid token'
            });
        }
        return next();
    }
    return res.status(401).send({
        error: 'Token required'
    });
}

verifyToken.unless = unless;

export default verifyToken;