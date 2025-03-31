import { createDepartment, deleteDepartment, getDepartments, updateDepartment } from "../Controller/department.controllers.js";
import { verifyToken } from "../utils/verification.js";
import express from "express";
const router = express.Router();




router.post("/create", verifyToken, createDepartment)

router.get("/getDepartments", verifyToken, getDepartments)
router.put("/update", verifyToken, updateDepartment)
router.delete("/delete", verifyToken, deleteDepartment)

export default router;
