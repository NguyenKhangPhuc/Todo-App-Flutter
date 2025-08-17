
import express, { Request, Response } from 'express';
import UserModel from '../models/user';
import { Token, User } from '../types/types';
import jwt from 'jsonwebtoken';
import { SECRET } from '../utils/config';
const userRouter = express.Router();

userRouter.post('/signup', async (req: Request<unknown, unknown, User>, res: Response) => {
    const newUser = req.body;
    const foundUser = await UserModel.findOne({ username: newUser.username });
    if (foundUser) {
        res.status(401).json({ error: 'User already exist' });
        return;
    }
    await UserModel.create(newUser);
    res.json({ mssg: 'create successfully' });
});

userRouter.post('/login', async (req: Request<unknown, unknown, User>, res: Response) => {
    console.log(req.body);
    const foundUser = await UserModel.findOne({ username: req.body.username, password: req.body.password });
    if (!foundUser) {
        res.status(401).json({ error: 'Wrong credentials' });
        return;
    }
    const userForToken: Token = {
        id: foundUser._id,
        username: foundUser.username
    };
    console.log(userForToken);

    try {
        const token = jwt.sign(userForToken, SECRET);
        console.log(token);
        res.json(token);
        return;
    } catch (error) {
        console.log(error);
    }
});


export default userRouter;