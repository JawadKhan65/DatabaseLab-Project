import express from "express";
import dotenv from "dotenv";
import { connectDB } from "./connectDB.js";
import userRoutes from './Routes/users.routes.js'
import inventoryRoutes from './Routes/inventory.routes.js'
import accessRoutes from './Routes/access_grant.routes.js'

dotenv.config();

const app = express();
app.use(express.json());

// routes configurations
app.use('/api/users', userRoutes); //express route usage for user related actions
app.use('/api/inventory', inventoryRoutes); //express route usage for inventory related actions
app.use('/api/access', accessRoutes); //express route usage for access related actions




app.get("/", async (req, res) => {
    try {

        res.json({ success: true, data: "API is running..." });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});


const PORT = process.env.PORT || 5000;
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});