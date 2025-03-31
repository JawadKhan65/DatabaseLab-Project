import { createSupplier, updateSupplier, deleteSupplier, getSuppliers } from "../Controller/supplier.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";

const router = express.Router()
router.post("/create", verifyToken, createSupplier)
router.get("/getSuppliers", verifyToken, getSuppliers)
router.put("/update", verifyToken, updateSupplier)
router.delete("/delete", verifyToken, deleteSupplier)

export default router;
