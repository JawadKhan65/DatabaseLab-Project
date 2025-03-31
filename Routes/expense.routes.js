import { createExpense, deleteExpense, getExpenses, updateExpense } from "../Controller/expense.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";


const router = express.Router();
router.post("/create", verifyToken, createExpense)
router.get("/getExpenses", verifyToken, getExpenses)
router.put("/update", verifyToken, updateExpense)
router.delete("/delete", verifyToken, deleteExpense)



export default router;
