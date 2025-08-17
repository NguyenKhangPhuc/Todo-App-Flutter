import { Schema, model } from "mongoose";
import { User } from "../types/types";

const userSchema = new Schema<User>({
    id: { type: String, require: true },
    username: { type: String, required: true },
    password: { type: String, required: true }
});

const UserModel = model<User>('User', userSchema);

export default UserModel;