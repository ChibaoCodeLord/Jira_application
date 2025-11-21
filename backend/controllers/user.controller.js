import { User } from "../models/user.js";
import  { sendSuccessResponse, sendErrorResponse } from "../utils/response.js";

export const searchUser = async (req, res) => {
  try {
    const q = req.query.q || "";

    const users = await User.searchByEmail(q);
    console.log("Search results:", users);
    console.log(`Number of users found: ${users.length}`);

    return sendSuccessResponse(res, 200, "Search completed successfully", {
      results: users.length,
      users,
    });
  } catch (err) {
    console.error(err);
    return sendErrorResponse(res, 500, err.message);
  }
};

export const getUserById = async (req, res) => {
  console.log('Called getUserById');
  try {
    const userId = req.params.id;
    
    const user = await User.getById(userId);
    if (!user) {
      return sendErrorResponse(res, 404, "User not found");
    }
    
    return sendSuccessResponse(res, 200, "User retrieved successfully", user);
  }
  catch (err) {
    console.error(err);
    return sendErrorResponse(res, 500, err.message);
  }
}
