import { NextFunction, Request, Response } from "express";
import { Token } from "../types/types";
import jwt from 'jsonwebtoken';
import { SECRET } from "./config";
import UserModel from "../models/user";
declare module "express-serve-static-core" {
    interface Request {
        user?: Token;
    }
}
export const tokenExtractor = async (req: Request, res: Response, next: NextFunction) => {
    const token = req.headers.authorization;
    console.log(token);
    if (token && token.startsWith('Bearer ')) {
        const receivedToken = token.substring(7);
        const decodedToken = jwt.verify(receivedToken, SECRET) as Token;
        if (decodedToken) {
            const foundUser = await UserModel.findById(decodedToken.id);
            if (!foundUser) {
                res.json({ error: 'Cannot find user' });
                return;
            }
            req.user = foundUser;
        } else {
            res.json({ error: 'Invalid Token' });
            return;
        }
    } else {
        res.json({ error: 'Missing token' });
        return;
    }
    next();
};
