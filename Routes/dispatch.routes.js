import { createDispatch } from "../controllers/dispatch_controller.js";
const dispatchRouter = express.Router();
dispatchRouter.post("/create", verifyToken, createDispatch);
export default dispatchRouter;
