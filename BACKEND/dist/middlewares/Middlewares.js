"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const express_unless_1 = require("express-unless");
const jwt = require('jsonwebtoken');
function verifyToken(req, res, next) {
    const token = req.body.token;
    if (token) {
        let decodedToken;
        try {
            decodedToken = jwt.verify(token, process.env.TOKEN_KEY);
        }
        catch (_a) {
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
verifyToken.unless = express_unless_1.unless;
exports.default = verifyToken;
