// eslint-disable-next-line @typescript-eslint/no-unsafe-call, @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-require-imports
require('dotenv').config();
const MONGODB_URI = process.env.MONGODB_URI ? process.env.MONGODB_URI : '';
const PORT = process.env.PORT;
const SECRET = process.env.SECRT || 'default';
export {
    MONGODB_URI,
    PORT,
    SECRET,
};