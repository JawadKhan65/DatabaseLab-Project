import express from "express";
import dotenv from "dotenv";
import { connectDB } from "./connectDB.js";

import userRoutes from './Routes/users.routes.js'
import inventoryRoutes from './Routes/inventory.routes.js'
import accessRoutes from './Routes/access_grant.routes.js'
import accountRoutes from './Routes/account.routes.js'
import dispatchRoutes from './Routes/dispatch.routes.js'
import orderRoutes from './Routes/order.routes.js'
import OtherInventoryRoutes from './Routes/otherInventory.routes.js'
import expenseRoutes from './Routes/expense.routes.js'
import purchaseRoutes from './Routes/purchase.routes.js'
import budgetRoutes from './Routes/budget.routes.js'
import departmentRoutes from './Routes/department.routes.js'
import salesRoutes from './Routes/sales.routes.js'
import supplierRoutes from './Routes/supplier.routes.js'

dotenv.config();

const app = express();
app.use(express.json());

// routes configurations

app.use('/api/users', userRoutes)
app.use('/api/inventory', inventoryRoutes)
app.use('/api/access', accessRoutes)
app.use('/api/account', accountRoutes)
app.use('/api/dispatch', dispatchRoutes)
app.use('/api/order', orderRoutes)
app.use('/api/otherInventory', OtherInventoryRoutes)
app.use('/api/expense', expenseRoutes)
app.use('/api/purchase', purchaseRoutes)
app.use('/api/budget', budgetRoutes)
app.use('/api/department', departmentRoutes)
app.use('/api/sales', salesRoutes)
app.use('/api/supplier', supplierRoutes)




app.get("/", async (req, res) => {
    try {

        res.json({ success: true, data: "API is running..." });
    } catch (error) {
        res.status(500).json({ success: false, error: error.message });
    }
});


const PORT = process.env.PORT || 5002;
app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});