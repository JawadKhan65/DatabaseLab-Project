import express from "express";
import { createOrder, deleteOrder, getOrders, updateOrder } from "../Controller/order.controllers.js";
import { verifyToken } from "../utils/verification.js";

const router = express.Router()
router.post("/create", verifyToken, createOrder)
router.get("/getOrders", verifyToken, getOrders)
router.put("/update", verifyToken, updateOrder)
router.delete("/delete", verifyToken, deleteOrder)

export default router;
