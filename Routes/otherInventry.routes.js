
import { createOtherInventory, getOtherInventories, updateOtherInventory, deleteOtherInventory } from "../controllers/other_inventory_controller.js";
const otherInventoryRouter = express.Router();
otherInventoryRouter.post("/create", verifyToken, createOtherInventory);
otherInventoryRouter.get("/list", verifyToken, getOtherInventories);
otherInventoryRouter.put("/update", verifyToken, updateOtherInventory);
otherInventoryRouter.delete("/delete", verifyToken, deleteOtherInventory);
export default otherInventoryRouter;
