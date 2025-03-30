import express from "express";
import { createOrder } from "../controllers/order_controller.js";
import { verifyToken } from "../utils/verification.js";

const orderRouter = express.Router();
orderRouter.post("/create", verifyToken, createOrder);
export default orderRouter;
