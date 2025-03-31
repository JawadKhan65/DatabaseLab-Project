import { createBudget, deleteBudget, getBudgets, updateBudget } from "../Controller/budget.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";
const router = express.Router();




router.post("/create", verifyToken, createBudget)
router.get("/getBudgets", verifyToken, getBudgets)
router.put("/update", verifyToken, updateBudget)
router.delete("/delete", verifyToken, deleteBudget)




export default router;
