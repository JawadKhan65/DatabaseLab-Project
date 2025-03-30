import { createSupplier } from "../controllers/supplier_controller.js";
const supplierRouter = express.Router();
supplierRouter.post("/create", verifyToken, createSupplier);
export default supplierRouter;
