import { Types } from "mongoose";

export interface User {
    id: string,
    username: string,
    password: string,
}

export interface Todo {
    id: string,
    title: string,
    isFinished: boolean
}

export interface Token {
    id: Types.ObjectId,
    username: string,
}