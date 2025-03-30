import { createDepartment } from "../controllers/department_controller.js";
const departmentRouter = express.Router();
departmentRouter.post("/create", verifyToken, createDepartment);
export default departmentRouter;
