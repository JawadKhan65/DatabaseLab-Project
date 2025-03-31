import { createSale, deleteSale, updateSale, getSales } from "../Controller/sales.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";
const router = express.Router()

router.post("/create", verifyToken, createSale)
router.get("/getSales", verifyToken, getSales)
router.put("/update", verifyToken, updateSale)
router.delete("/delete", verifyToken, deleteSale)

export default router;
