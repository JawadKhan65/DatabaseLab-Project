import { createAccount } from "../controllers/account_controller.js";
const accountRouter = express.Router();
accountRouter.post("/create", verifyToken, createAccount);
export default accountRouter;
