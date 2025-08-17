import express, { Request, Response } from 'express';
import TodoModel from '../models/todo';
import { Todo } from '../types/types';
import { tokenExtractor } from '../utils/middleware';

const todoRouter = express.Router();

todoRouter.get('/', tokenExtractor, async (_: Request, res: Response) => {
    const response = await TodoModel.find({});
    res.json(response);
});


todoRouter.post('/', tokenExtractor, async (req: Request<unknown, unknown, Todo>, res: Response) => {
    const response = await TodoModel.create(req.body);
    res.json(response);
    return;
});

todoRouter.delete('/', async (_: Request, res: Response) => {
    await TodoModel.deleteMany({});
    res.status(204).end();
});

todoRouter.delete('/delete-finished', async (_: Request, res: Response) => {
    await TodoModel.deleteMany({ isFinished: true });
    res.status(204).end();
});

todoRouter.delete('/:id', async (req: Request<{ id: string }, unknown, unknown>, res: Response) => {
    await TodoModel.findByIdAndDelete(req.params.id);
    res.status(204).end();
});

todoRouter.put('/:id', async (req: Request<{ id: string }, unknown, unknown>, res: Response) => {
    const response = await TodoModel.findById(req.params.id);
    if (!response) {
        res.json({ error: 'Cannot find todo' });
        return;
    }
    response.isFinished = !response.isFinished;
    await response.save();
    res.json({ mssg: 'Update successfully' });
});

export default todoRouter;