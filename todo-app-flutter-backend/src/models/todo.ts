import { model, Schema } from "mongoose";
import { Todo } from "../types/types";


const todoSchema = new Schema<Todo>({
    id: { type: String },
    title: { type: String, required: true },
    isFinished: { type: Boolean, required: true }
});

const TodoModel = model<Todo>('Todo', todoSchema);

export default TodoModel;