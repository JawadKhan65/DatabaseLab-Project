import { createPurchase, deletePurchase, getPurchases, updatePurchase } from "../Controller/purchase.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";
const router = express.Router();
router.post("/create", verifyToken, createPurchase)
router.get("/getPurchases", verifyToken, getPurchases)
router.put("/update", verifyToken, updatePurchase)
router.delete("/delete", verifyToken, deletePurchase)

export default router;
